module StippleLatex

import Genie
import Stipple
import Genie.Renderer.Html: HTMLString, normal_element

using Stipple.Reexport

export latex

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

Genie.Renderer.Html.register_normal_element("katex__element", context = @__MODULE__)

function latex( fieldname::Union{Symbol,Nothing} = nothing,
                args...;
                wrap::Function = StippleUI.DEFAULT_WRAPPER,
                kwargs...) where {T<:Stipple.ReactiveModel}
  wrap() do
    katex__element(args...; kwargs...)
  end
end

end
