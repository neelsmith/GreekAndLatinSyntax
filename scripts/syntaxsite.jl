#= 
    This script reads a delimited-text file with syntactic annotations, and for each annotated sentence generates a `png` image for its syntax diagram, and a web page including a link to the image.

    To use it, check the three required settings identified in the following comments.
=#
script_version = "1.0.1"
originaldir = pwd()
@info("Starting from directory $(originaldir)")

#= There are three required settings: =#
#1: directory where output will be written
outputdir = joinpath(originaldir, "debug", "lysias1_site")
#2: title for your text
textlabel = "Lysias 1"
#3:  source for your syntactic annotations.
# You can either use a local file, or download a file from a URL.  Uncomment only ONE of these two settings.
# (If you leave both uncommented, the the URL takes precedence over the local file.)
annotations_file = joinpath(pwd(), "data", "Lysias1_annotations.cex")
#annotations_url = "https://raw.githubusercontent.com/neelsmith/GreekAndLatinSyntax/main/data/Lysias1_annotations.cex"

# set up environment: you shouldn't touch this bit.

using Pkg
workspace = tempdir()
cd(workspace)
Pkg.activate(workspace)
Pkg.add("GreekSyntax")
Pkg.add("Downloads")
Pkg.add("CitableText")
Pkg.add("Dates")
Pkg.update()
cd(originaldir)

#= 2. Optionally, you may define your own CSS.

Each web page includes:

- 2 divs of class `passage`, with two different text displays of the passage.  Each div is accompanied by a div of class `key` with a key to interpreting the visual formatting of the passage.
- 1 div of class `diagram` with a link to the png file for this sentence.

=#
using GreekSyntax
css_text = GreekSyntax.defaultcss()
page_css = GreekSyntax.pagecss()

#= 3. Good to go!  The rest of this script should run
without any further modification.
=#
if @isdefined(annotations_url)
    using Downloads
    annotations_file = Downloads.download(annotations_url)
end
(sentences, groups, tokens) = annotations_file |> readlines |> readdelimited


# Directory where we'll write PNGs to link to:
pngdir = joinpath(outputdir, "pngs")
mkpath(pngdir)
@info("Created directory $(pngdir)")

# CSS files to link to in web pages:
open(joinpath(outputdir, "syntax.css"), "w") do io
    write(io, GreekSyntax.defaultcss() * "\n")
end
open(joinpath(outputdir, "page.css"), "w") do io
    write(io, GreekSyntax.pagecss())
end

using CitableText # for manipulating CTS URNS
using Dates

"""Wrap page title and body content in HTML elements,
and include link to syntax.css.
"""
function wrap_page(title, content)
    """<html>
    <head>
    <title>$(title)</title>
    <link rel=\"stylesheet\" href=\"syntax.css\">
    <link rel=\"stylesheet\" href=\"page.css\">
    </head>
    <body>$(content)</body>
    </html>"""
end

"""Compose navigation links for page with index `idx`.
"""
function navlinks(idx::Int, sentencelist::Vector{SentenceAnnotation})
    nxt = ""
    prev = ""
    if idx == 1
        nxtpsg = sentences[idx + 1].range |> passagecomponent
        nxt = "<a href=\"./$(nxtpsg).html\">$(nxtpsg)</a>"
    
        prev = ""
        
    elseif idx == length(sentences)
        nxt = ""

        prevpsg = sentences[idx - 1].range |> passagecomponent
        prev = "<a href=\"./$(prevpsg).html\">$(prevpsg)</a>"

    else
        nxtpsg = sentences[idx + 1].range |> passagecomponent
        nxt = "<a href=\"./$(nxtpsg).html\">$(nxtpsg)</a>"

        prevpsg = sentences[idx - 1].range |> passagecomponent
        prev = "<a href=\"./$(prevpsg).html\">$(prevpsg)</a>"
    end
nav = "<p class=\"nav\">$(prev) | $(nxt)</p>"
end

"""Compose HMTL page for sentence number `idx`.
"""
function webpage(idx, sentences, groups, tokens)
    sentence = sentences[idx]
    @info("$(idx). Writing page for $(sentence.sequence) == $(sentence.range)...")

    # Compose parts of page content:

    #  Heading and subheading
    psg = passagecomponent(sentence.range)
    pagetitle = "$(textlabel),  $(psg)"
    hdg = "<h1>$(pagetitle)</h1>"
    subhead = "<h2>Sentence $(sentence.sequence)</h2>"
     
    # navigation links
    nav = navlinks(idx, sentences)

    # Continuous text view:
    plaintext = htmltext(sentence.range, sentences, tokens, sov = false, vucolor = false)


    # Text colored by verbal expression:
    key1 = "<div class=\"key right\"><strong>Highlighting</strong>:" *  GreekSyntax.sovkey() * "</div>"
    txtdisplay1 = "<div class=\"passage\">" * htmltext_indented(sentence, groups, tokens, sov = true, vucolor = false) * "</div>"

    # Text indented by level of subordination
    pagegroups = GreekSyntax.groupsforsentence(sentence, groups)
    key2 = "<div class=\"key left\"><strong>Color code</strong>:" * GreekSyntax.htmlgrouplist(pagegroups) * "</div>"
    txtdisplay2 = "<div class=\"passage\">" * htmltext(sentence, tokens, sov = true, vucolor = true) * "</div>"

    # Syntax diagram (pre-generated PNG)
    @info("Linking to image for $(sentence.sequence) == $(sentence.range)")
    imglink = "<img src=\"pngs/sentence_$(sentence.sequence).png\" alt=\"Syntax diagram, sentence $(sentence.sequence)\"/>"
    diagram = "<div class=\"diagram\">" * imglink * "</div>"
    
    m = now() |> monthname
    d = now() |> day
    y = now() |> year
    footer = "<footer>Site created by <code>syntaxsite.jl</code>, version $(script_version), on $(m) $(d), $(y).</footer>"

    # String all the parts together!
    htmlparts = [hdg, nav, subhead, plaintext, txtdisplay1, txtdisplay2, key1, key2, diagram, footer]
    bodycontent = join(htmlparts, "\n\n")
    wrap_page(pagetitle, bodycontent)
end


function publishsentence(num, sentences, groups, tokens; pngdir = pngdir, outdir = outputdir)
    idx = findfirst(s -> s.sequence == num, sentences)
    # Write png for page:
    sentence = sentences[idx]
    @info("Composing diagram for sentence $(num) == $(sentence.range)")
    pngout = mermaiddiagram(sentence, tokens, format = "png")
    write(joinpath(pngdir, "sentence_$(sentence.sequence).png"), pngout)

    psg = passagecomponent(sentence.range)
    pagehtml = webpage(idx, sentences, groups, tokens)
    open(joinpath(outputdir, "$(psg).html"), "w") do io
        write(io, pagehtml)
    end
    @info("Done: wrote HTML page for sentence $(num) in $(outputdir) as $(psg).html.")
end


function publishall(sentences, groups, tokens)
    for sentence in sentences
        publishsentence(sentence.sequence, sentences, groups, tokens)   
    end
    @info("Done: wrote $(length(sentences)) HTML pages linked to accompanying PNG file in $(outputdir). (Now in $(pwd()))")
end

publishall(sentences, groups, tokens)


# This works if you want to republish a specific sentence identified
# by its sequence number:
#publishsentence(11, sentences, groups, tokens)  

