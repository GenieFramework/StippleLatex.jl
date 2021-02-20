module StippleKatex

import Genie
import Stipple

using Stipple.Reexport

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

  string(
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/katex.min.js"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/auto-render.min.js", onload="renderMathInElement(document.body);"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/vue-katex.min.js"),
    Genie.Renderer.Html.link(href="$(Genie.config.base_path)js/stipplekatex/katex.min.css", rel="stylesheet"),
  )
end

#===#

function __init__()
  push!(Stipple.DEPS, deps)
end

end
