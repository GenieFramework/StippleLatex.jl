using StippleLatex
using Stipple
using Test

@testset "StippleLatex.jl" begin
    @testset "latex() function" begin
        # Test basic latex with string content
        result = latex(raw"\cos^2x")
        @test result isa Stipple.ParsedHTMLString
        @test occursin("v-katex", string(result))
        @test occursin(raw"\cos^2x", string(result))

        # Test latex with Symbol content
        result = latex(:formula)
        @test result isa Stipple.ParsedHTMLString
        @test occursin("v-katex", string(result))
        @test occursin("expression", string(result))  # Symbol creates JSONText in expression field

        # Test display mode
        result = latex(raw"\int f(x) dx", display = true)
        @test occursin("displayMode", string(result))
        @test occursin("true", string(result))

        # Test auto mode with string
        result = latex(raw"Some text with \(\cos x\)", auto = true)
        @test occursin("v-katex:auto", string(result))
        @test occursin(raw"Some text with \(\cos x\)", string(result))

        # Test auto mode with Symbol
        result = latex(:myformula, auto = true)
        @test occursin("v-katex:auto", string(result))
        @test occursin("myformula", string(result))

        # Test error handling options
        result = latex(raw"\sin x", throw_on_error = true, error_color = "#FF0000")
        @test occursin("throwOnError", string(result))
        @test occursin("true", string(result))
        @test occursin("errorColor", string(result))
        @test occursin("#FF0000", string(result))

        # Test max_expand option
        result = latex(raw"\sin x", max_expand = 500)
        @test occursin("maxExpand", string(result))
        @test occursin("500", string(result))

        # Test strict option
        result = latex(raw"\sin x", strict = "error")
        @test occursin("strict", string(result))
        @test occursin("error", string(result))

        # Test expression parameter
        result = latex(expression = raw"\tan^2 x")
        @test occursin(raw"\tan^2 x", string(result))

        # Test with custom HTML attributes
        result = latex(raw"\pi", class = "my-class", id = "my-id")
        @test occursin("v-katex", string(result))
        @test occursin("class=\"my-class\"", string(result))
        @test occursin("id=\"my-id\"", string(result))
    end

    @testset "dictvalue() helper" begin
        # Test Symbol conversion
        result = StippleLatex.dictvalue(:myvar)
        @test result isa Stipple.JSONText
        @test occursin("myvar", string(result))

        # Test non-Symbol pass-through
        @test StippleLatex.dictvalue(true) === true
        @test StippleLatex.dictvalue(42) === 42
        @test StippleLatex.dictvalue("text") === "text"
    end

    @testset "Module initialization" begin
        # Test that deps are registered
        @test StippleLatex.deps isa Function
        deps_list = StippleLatex.deps()
        @test deps_list isa Vector{String}
        @test any(d -> occursin("katex.min.js", d), deps_list)
        @test any(d -> occursin("katex.min.css", d), deps_list)
        @test any(d -> occursin("vue-katex.umd.js", d), deps_list)
        @test any(d -> occursin("auto-render.min.js", d), deps_list)
        @test any(d -> occursin("deepmerge.umd.js", d), deps_list)
    end

    @testset "Exports" begin
        # Test that main functions are exported
        @test isdefined(StippleLatex, :latex)
        @test isdefined(StippleLatex, Symbol("@latex"))
        @test isdefined(StippleLatex, Symbol("@latex_str"))
    end

    @testset "Component registration" begin
        @test StippleLatex.COMPONENTS isa Vector
        @test length(StippleLatex.COMPONENTS) == 1
        @test StippleLatex.COMPONENTS[1] == ("'vue-katex'" => :vueKatex)
    end

    @testset "Options handling" begin
        # Test all available options
        result = latex(raw"E = mc^2",
            display = true,
            throw_on_error = false,
            error_color = "#FF0000",
            max_size = "1000",
            max_expand = 2000,
            allowed_protocols = ["http", "https"],
            strict = "ignore")

        result_str = string(result)
        @test occursin("displayMode", result_str)
        @test occursin("true", result_str)
        @test occursin("throwOnError", result_str)
        @test occursin("false", result_str)
        @test occursin("errorColor", result_str)
        @test occursin("#FF0000", result_str)
        @test occursin("maxSize", result_str)
        @test occursin("1000", result_str)
        @test occursin("maxExpand", result_str)
        @test occursin("2000", result_str)
        @test occursin("allowedProtocols", result_str)
        @test occursin("http", result_str)
        @test occursin("strict", result_str)
        @test occursin("ignore", result_str)
    end
end
