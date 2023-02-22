# StippleLatex

StippleLatex uses Vue-Katex to imlement LaTeX-Formatting in Stipple.
There are three possibilities of entering LaTeX content in your web page
- Latex-span element.

    `latex(<LaTeX formula>, <formatting options>)`

- HTML element with latex content via string macro with an optional modifier which can take the values `auto`or `display`

    `span(latex"<LaTeX formula>")`  
    `span(latex"<LaTeX formula>"display)`

- HTML element with latex content via `@latex` macro with additional options

    `span(@latex(raw"<LaTeX formula>")`  
    `span(@latex(raw"<LaTeX formula>", display = true)`

All arguments also support Symbols to bind to model fields.
Here's a demo app that shows possible use cases.

```julia
using Stipple, Stipple.ReactiveTools
using StippleUI
using StippleLatex

function nestlist(f, a; init = nothing)
    T = eltype(a)
    list = T[]
    el = init
    for (i, x) in enumerate(a)
        el = i == 1 && init === nothing ? x : f(el, x)
        push!(list, el)
    end
    list
end

formula = nestlist(*, ["", raw"\sin", "^2", " x", " +", raw" \sqrt{", "a", "^2", " +", " b", "^2"])
formula[contains.(formula, "sqrt")] .*= "}"

@app begin
    @in x = 0
    @in formula_1 = raw"\int_{a}^{b} f(x) \, dx = F(x)\Biggr|^b_a"
    @in formula_2 = raw""
    @private p = @task 1 + 1

    @onchange isready begin
        if !istaskstarted(p) || istaskdone(p) 
            p = @task begin
                println("Task started")
                while x <= 100
                    x = x + 1
                    pos = x < 6 ? 1 : (x - 5) % (length(formula) + 5) + 1
                    formula_2 = formula[min(pos, length(formula))]
                    sleep(1)
                end
            end
            schedule(p)
        end
    end
end

@init()
function ui()
    [
        row(cell(class = "st-module", [
            cell(h1(latex("\\LaTeX") * "-Demo"))
            cell(h2(latex"a^2 + b^2 = c^2"))
        ]))

        row(cell(class = "st-module", [
            textfield("Enter your LaTeX-Forumla", :formula_1,)
            cell(class = "q-pa-md", latex":formula_1")
            cell(class = "q-pa-md", latex"\cos^2x"display)
            latex(class = "q-pa-md", raw"\tan^2x", display = true)
            bignumber("Wait for 5", :x, color = R"x >= 5 ? 'negative' : 'positive'", icon = "calculate")
            cell(class = "q-pa-md", @latex(raw"\tanh^2 y", display = R"x >= 5"))
        ]))

        row(cell(class = "st-module", [
            textfield(class = "q-pa-lg", "LaTeX", :formula_2)
            cell(class = "q-pa-md", "Result:")
            cell(class = "q-pa-md", latex":formula_2"auto)

        ]))
    ]
end

route("/") do
    page(@init(), ui()) |> html
end
    
up()
```

