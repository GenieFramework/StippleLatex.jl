using Genie, Genie.Renderer.Html, Stipple, StippleLatex, LatexPrint

Genie.config.log_requests = false
# Genie.config.base_path = "/proxy/9000/"

Base.@kwdef mutable struct Name <: ReactiveModel
  name::R{String} = "World!"
end

Stipple.register_components(Name, StippleLatex.COMPONENTS)

model = Stipple.init(Name(), transport = Genie.WebChannels)

function ui()
  page(
    vm(model), class="container",
    [
      h1([
        "Hello "
        span("", @text(:name), @latex!!(:name))
      ])

      p([
        "What is your name? "
        input("", placeholder="Type your name", @bind(:name))
      ])

      # latex(raw"\\frac{a_i}{1+x}", display = true)
    ]
  ) |> html
end

route("/", ui)

up()