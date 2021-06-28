module StippleLatex

import Genie
import Stipple

using Stipple.Reexport

export latex, @latex, @latex!!

const DEFAULT_WRAPPER = Genie.Renderer.Html.template
const COMPONENTS = ["'vue-katex'" => :vueKatex]

#===#

function deps() :: String
  Genie.Router.route("/js/stipplekatex/katex.min.css") do
    Genie.Renderer.WebRenderable(
      read(joinpath(@__DIR__, "..", "files", "katex.min.css"), String),
      :css) |> Genie.Renderer.respond
  end
  Genie.Router.route("/js/stipplekatex/katex.min.js") do
    Genie.Renderer.WebRenderable(
      read(joinpath(@__DIR__, "..", "files", "katex.min.js"), String),
      :javascript) |> Genie.Renderer.respond
  end
  Genie.Router.route("/js/stipplekatex/auto-render.min.js") do
    Genie.Renderer.WebRenderable(
      read(joinpath(@__DIR__, "..", "files", "auto-render.min.js"), String),
      :javascript) |> Genie.Renderer.respond
  end
  Genie.Router.route("/js/stipplekatex/vue-katex.min.js") do
    Genie.Renderer.WebRenderable(
      read(joinpath(@__DIR__, "..", "files", "vue-katex.min.js"), String),
      :javascript) |> Genie.Renderer.respond
  end

  Genie.Router.route("/js/stipplekatex/fonts/KaTeX_Main-Regular.woff2") do
    Genie.Renderer.WebRenderable(
      read(joinpath(@__DIR__, "..", "files", "fonts", "KaTeX_Main-Regular.woff2"), String),
      :fontwoff2) |> Genie.Renderer.respond
  end
  Genie.Router.route("/js/stipplekatex/fonts/KaTeX_Math-Italic.woff2") do
    Genie.Renderer.WebRenderable(
      read(joinpath(@__DIR__, "..", "files", "fonts", "KaTeX_Math-Italic.woff2"), String),
      :fontwoff2) |> Genie.Renderer.respond
  end

  string(
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/katex.min.js"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/auto-render.min.js", onload="renderMathInElement(document.body);"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/vue-katex.min.js", defer=true),
    Genie.Renderer.Html.link(href="$(Genie.config.base_path)js/stipplekatex/katex.min.css", rel="stylesheet"),
  )
end

#===#

function __init__()
  push!(Stipple.DEPS, deps)
end

#===#

function latex(content::String = "",
                args...;
                wrap::Function = DEFAULT_WRAPPER,
                expression::String = "",
                auto::Bool = true,
                display::Bool = false,
                throw_on_error::Bool = false,
                error_color::String = "#CC0000",
                max_size::String="Infinity",
                max_expand::Union{String,Number} = 1000,
                allowed_protocols::Vector{String} = String[],
                strict::Union{Bool,String} = "warn",
                kwargs...)
  isempty(expression) || (content = expression)
  options = Dict(:displayMode => display,
                  :throwOnError => throw_on_error,
                  :errorColor => error_color,
                  :maxSize => max_size,
                  :maxExpand => max_expand,
                  :allowedProtocols => allowed_protocols,
                  :strict => strict)
  arguments = "{ expression: '$(content)', options: $(Stipple.JSONParser.json(options)) }"
  arguments = replace(arguments, '"'=>"'")

  wrap() do
    auto ?
      Genie.Renderer.Html.div(v__katex!!auto = arguments, args...; kwargs...) :
      Genie.Renderer.Html.div(v__katex = arguments, args...; kwargs...)
  end
end


macro latex(expr)
  quote
    "v-katex:auto='$($(esc(expr)))'"
  end
end

macro latex!!(expr)
  quote
    "v-katex:display='$($(esc(expr)))'"
  end
end

end
