module StippleLatex

import Genie
import Stipple

using Stipple.Reexport

export latex, @latex, @latex_str

const COMPONENTS = ["'vue-katex'" => :vueKatex]

#===#

function deps() :: Vector{String}
  [
    Genie.Renderer.Html.script("vueLegacy.context = 'Latex'"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)stipplelatex/assets/katex/deepmerge.umd.js"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)stipplelatex/assets/katex/katex.min.js"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)stipplelatex/assets/katex/auto-render.min.js"),
    Genie.Renderer.Html.script(src="$(Genie.config.base_path)stipplelatex/assets/katex/vue-katex.umd.js", defer=true),
    Genie.Renderer.Html.link(href="$(Genie.config.base_path)stipplelatex/assets/katex/katex.min.css", rel="stylesheet"),
  ]
end

#===#

function __init__()
  Stipple.deps!(@__MODULE__, deps)
  Stipple.add_plugins(StippleLatex, "Latex"; legacy = true)

  Genie.Router.route("/stipplelatex/assets/katex/katex.min.css") do
    Genie.Renderer.WebRenderable(
      read(joinpath(@__DIR__, "..", "files", "katex.min.css"), String),
      :css) |> Genie.Renderer.respond
    end
    
  filenames = ["katex.min.js", "auto-render.min.js", "vue-katex.umd.js", "deepmerge.umd.js"]
  for filename in filenames
    Genie.Router.route("/stipplelatex/assets/katex/$filename") do
      Genie.Renderer.WebRenderable(
        read(joinpath(@__DIR__, "..", "files", filename), String),
        :javascript) |> Genie.Renderer.respond
    end
  end

  filenames = [
    "KaTeX_AMS-Regular.woff2", "KaTeX_Caligraphic-Bold.woff2", "KaTeX_Caligraphic-Regular.woff2", 
    "KaTeX_Fraktur-Bold.woff2", "KaTeX_Fraktur-Regular.woff2", "KaTeX_Main-Bold.woff2", 
    "KaTeX_Main-BoldItalic.woff2", "KaTeX_Main-Italic.woff2", "KaTeX_Main-Regular.woff2", 
    "KaTeX_Math-BoldItalic.woff2", "KaTeX_Math-Italic.woff2", "KaTeX_SansSerif-Bold.woff2", 
    "KaTeX_SansSerif-Italic.woff2", "KaTeX_SansSerif-Regular.woff2", "KaTeX_Script-Regular.woff2", 
    "KaTeX_Size1-Regular.woff2", "KaTeX_Size2-Regular.woff2", "KaTeX_Size3-Regular.woff2", 
    "KaTeX_Size4-Regular.woff2", "KaTeX_Typewriter-Regular.woff2"
  ]
  for filename in filenames
    Genie.Router.route("/stipplelatex/assets/katex/fonts/$filename") do
      Genie.Renderer.WebRenderable(
        read(joinpath(@__DIR__, "..", "files", "fonts", filename), String),
        :fontwoff2) |> Genie.Renderer.respond
    end
  end
end

#===#

function latex(content::Union{String, Symbol} = "",
                args...;
                expression::String = "",
                auto::Bool = false,
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
  output = content isa Symbol ? Stipple.JSONText(String(content)) : String(content)
  d = auto ? Dict(:options => options) : Dict(:expression => output, :options => options)
  katexdict = Stipple.JSONText("'$(Stipple.JSONParser.write(d))'")

  if auto
    if content isa Symbol
      Genie.Renderer.Html.span(var"v-katex:auto" = katexdict, "{{ $content }}", args...; kwargs...)
    else
      Genie.Renderer.Html.span(content, var"v-katex:auto" = katexdict, args...; kwargs...)
    end
  else
    Genie.Renderer.Html.span(var"v-katex" = katexdict, args...; kwargs...)
  end
end

macro latex_str(expr)
  expr = startswith(expr, ':') ? :($expr[2:end]) : :("'" * Stipple.JSONParser.write($expr)[2:end-1] * "'")
  Expr(:kw, Symbol("v-katex"), expr)
end

macro latex_str(expr, mode)
  if mode == "auto"
    startswith(expr, ':') ? :((["{{ $($(expr[2:end])) }}"], "v-katex:$($mode)")...) : :(([$expr], "v-katex:$($mode)")...)
  else
    newexpr = startswith(expr, ':') ? :($expr[2:end]) : :("'" * Stipple.JSONParser.write($expr)[2:end-1] * "'")
    Expr(:kw, Symbol("v-katex", ":", mode), newexpr)
  end
end

function dictvalue(@nospecialize(x))
  x isa Symbol ? Stipple.JSONText("($x)") : x
end

function latex_expr(content::Union{String, Symbol} = "",
                    args...;
                    expression::String = "",
                    auto::Bool = false,
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
  output = content isa Symbol ? Stipple.JSONText(String(content)) : String(content)
  d = auto ? Dict(:options => options) : Dict(:expression => output, :options => options)
  katexdict = Stipple.JSONText("'$(Stipple.JSONParser.write(d))'")

  if auto
    if content isa Symbol
      :((["{{ $($content) }}"], "v-katex:auto = $($(katexdict.s))")...) |> esc
    else
      :(([$content], "v-katex:auto = $($(katexdict.s))")...) |> esc
    end
  else
    Expr(:kw, Symbol("v-katex"), d)
  end
end

macro latex(args...)
  for (i, a) in enumerate(args)
    a isa Expr && a.head == :(=) && (args[i].head = :kw)
  end
  @eval __module__ StippleLatex.latex_expr($(args...))
end

end
