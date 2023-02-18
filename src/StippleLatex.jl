module StippleLatex

import Genie
import Stipple

using Stipple.Reexport

export latex, @latex, @latex_str

const COMPONENTS = ["'vue-katex'" => :vueKatex]

#===#

function deps() :: Vector{String}
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

  [
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/katex.min.js"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/auto-render.min.js", onload="renderMathInElement(document.body);"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)js/stipplekatex/vue-katex.min.js", defer=true),
    Genie.Renderer.Html.link(href="$(Genie.config.base_path)js/stipplekatex/katex.min.css", rel="stylesheet"),
  ]
end

#===#

function __init__()
  Stipple.deps!(@__MODULE__, deps)
end

#===#

function latex(content::Union{String, Symbol} = "",
                args...;
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
  options = Dict(:displayMode => dictvalue(display),
    :throwOnError => dictvalue(throw_on_error),
    :errorColor => dictvalue(error_color),
    :maxSize => dictvalue(max_size),
    :maxExpand => dictvalue(max_expand),
    :allowedProtocols => dictvalue(allowed_protocols),
    :strict => dictvalue(strict)
  )
  attr = if content isa Symbol
    String(content)
  else
    Stipple.JSONText("'$(Stipple.JSONParser.write(Dict(:expression => content, :options => options)))'")
  end

  auto ?
    Genie.Renderer.Html.span(var"v-katex:auto" = attr, args...; kwargs...) :
    Genie.Renderer.Html.span(var"v-katex" = attr, args...; kwargs...)
end

macro latex_str(expr)
  expr = startswith(expr, ':') ? :($expr[2:end]) : :("'" * Stipple.JSONParser.write($expr)[2:end-1] * "'")
  Expr(:kw, Symbol("v-katex"), expr)
end

macro latex_str(expr, mode)
  expr = startswith(expr, ':') ? :($expr[2:end]) : :("'" * Stipple.JSONParser.write($expr)[2:end-1] * "'")
  Expr(:kw, Symbol("v-katex", ":", mode), expr)
end

function dictvalue(@nospecialize(x))
  x isa Symbol ? Stipple.JSONText("($x)") : x
end

function latex_expr(content::Union{String, Symbol} = "",
                    args...;
                    expression::String = "",
                    auto::Bool = true,
                    display::Union{Symbol, Bool} = false,
                    throw_on_error::Bool = false,
                    error_color::String = "#CC0000",
                    max_size::String="Infinity",
                    max_expand::Union{String,Number} = 1000,
                    allowed_protocols::Vector{String} = String[],
                    strict::Union{Bool,String} = "warn",
                    kwargs...)
isempty(expression) || (content = expression)
options = Dict(:displayMode => dictvalue(display),
  :throwOnError => dictvalue(throw_on_error),
  :errorColor => dictvalue(error_color),
  :maxSize => dictvalue(max_size),
  :maxExpand => dictvalue(max_expand),
  :allowedProtocols => dictvalue(allowed_protocols),
  :strict => dictvalue(strict)
)
attr = if content isa Symbol
  String(content)
else
  Stipple.JSONText("'$(Stipple.JSONParser.write(Dict(:expression => content, :options => options)))'")
end
  auto ? Expr(:kw, Symbol("v-katex:auto"), attr) : Expr(:kw, Symbol("v-katex"), attr)
end

macro latex(args...)
  for (i, a) in enumerate(args)
    a isa Expr && a.head == :(=) && (args[i].head = :kw)
  end
  @eval __module__ StippleLatex.latex_expr($(args...))
end

end
