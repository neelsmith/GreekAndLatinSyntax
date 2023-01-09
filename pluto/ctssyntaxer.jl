### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 2009a8a2-7f18-11ed-32f5-2d0ae7ffdde8
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate(pwd())
	Pkg.update()
	Pkg.instantiate()

	Pkg.add("GreekSyntax")
	using GreekSyntax
	
	Pkg.add("LatinSyntax")
	using LatinSyntax

	Pkg.add("PlutoUI")
	using PlutoUI
	import PlutoUI: combine
	
	Pkg.add("Kroki")
	using Kroki

	Pkg.add("CitableBase")
	using CitableBase
	Pkg.add("CitableText")
	using CitableText
	Pkg.add("CitableCorpus")
	using CitableCorpus

	Pkg.add("Orthography")
	using Orthography

	Pkg.add("PolytonicGreek")
	using PolytonicGreek

	Pkg.add("LatinOrthography")
	using LatinOrthography
	
	Pkg.add("PlutoTeachingTools")
	using PlutoTeachingTools

	Pkg.add("HypertextLiteral")
	using HypertextLiteral
	
	Pkg.add("DataFrames")
	using DataFrames
	Pkg.add("UUIDs")
	using UUIDs

	Pkg.add(url = "https://github.com/lungben/PlutoGrid.jl")
	using PlutoGrid

	Pkg.status()
	md"""(*Unhide this cell to see environment setup.*)"""
end

# ╔═╡ d345d44b-a9ed-4d70-a470-1f1cb53a18a9
TableOfContents() 

# ╔═╡ 31cc3ad6-ac34-49f7-a86f-575a08eb1358
nbversion = "0.7.0";

# ╔═╡ ed67e569-147c-4899-b338-f3282d9474b1
md"""(*Notebook version **$(nbversion)**.*) *See version history* $(@bind history CheckBox(false))"""

# ╔═╡ d227b2f4-5cdd-4ef6-ae7c-0a8f02f1f966
if history
md"""

- **0.7.0**: Works with either Greek or Latin texts.
- **0.6.0**: Allow loading source data from file or URL.
- **0.5.1**: Fixes a bug in serializing verbal expressions.
- **0.5.0**: Uses new `GreekSyntax` package to simplify notebook. Fixes syntax error in default color palette.
- **0.4.1**: fixes a boundary-checking error in using multiple connectors.
- **0.4.0**: reorganizes tips and instructions using `aside` from `PlutoTeachingTools`; allows selection of a *range* of connecting words; corrects bug in display of indented syntactic units.
- **0.3.0**: changes user interface for defining verbal units and grouping tokens by verbal unit.  Saving files uses a rational clickable button (the underdocumented `CounterButton` in PlutoUI).
- **0.2.0**: reorganizes notebook in preparation for publication of `GreekSyntax` package on juliahub, and changes to writing all delimited-text serialization of annotations to a single file.
- **0.1.1**: bug fixes, including important correction to sentence + group ID in export of token annotations.
- **0.1.0** initial version:  load a citable corpus from CEX source, validate its orthography and parse into sentence units citable by CTS URN, save annotation results to delimited-text files.
"""
	
else
		md""
	
	
end

# ╔═╡ 44a1635c-41af-450e-b06e-670367ae489b
md"""


## Annotate the syntax of a citable Greek or Latin text

> *Annotate the syntax of a citable Greek or Latin text, and save your annotations to simple delimited text files.*


"""

# ╔═╡ d865bcd7-ef34-48d1-9526-623578822e42
md"""### Prerequisites: configuring your notebook"""

# ╔═╡ ccb5e655-9bb1-4117-9231-f9a90855b48b
md"""*Please provide a title for your collection of annotations.*

*Title*: $(@bind title confirm(TextField(80; placeholder = "Title for text")))
"""


# ╔═╡ 3c3003e6-ebe9-434a-8960-6504b0e1578e
begin
	defaultdir = joinpath(pwd(), "output")
	md"""*Directory where results will be saved*: $(@bind outputdir confirm(TextField(80, default = defaultdir)))"""
# *Title*: $(@bind title TextField(80; placeholder = "Title for text"))
end

# ╔═╡ a6a283db-692c-43ff-8c43-6038d3bc2ed2
md"""*Load citable text from* $(@bind srctype Select(["", "url", "file"]))"""

# ╔═╡ 9d8b4b7c-f6f6-4f53-9f08-0854069f658b
if srctype == "url"
	md"""
*Paste or type in a URL for the CEX source file to annotate.*	
	*Source URL*: $(@bind srcurl confirm(TextField(80; default = 
	"https://raw.githubusercontent.com/neelsmith/GreekAndLatinSyntax/main/data/texts/lysias1.cex")))
	"""



elseif srctype == "file"
	
	defaultsrcdir = joinpath(dirname(pwd()), "data", "texts")
	md"""*Source directory*: $(@bind basedir confirm(TextField(80; default = defaultsrcdir)))"""
end

# ╔═╡ de0e1c93-4e9a-40da-bf76-b9952d2da2ae
if srctype == "file"
	
	cexfiles = filter(readdir(basedir)) do fname
		endswith(fname, ".cex")
	end
	datasets = [""]
	for f in cexfiles
		push!(datasets,f)
	end
	md"""*Choose a file* $(@bind datafile Select(datasets))"""
end

# ╔═╡ 2d13c642-7c89-4e47-bad0-0a5ff98e1d8d
begin
	orthomenu = ["litgreek" => "Greek: literary orthography", "latin23" => "Latin: 23-character alphabet","latin24" => "Latin: 24-character alphabet", "latin25" => "Latin: 25-character alphabet"]
	
md"""
*Language and orthography of your corpus*: $(@bind ortho Select(orthomenu))
"""
end

# ╔═╡ 73cb1d9d-c265-46c5-ae8d-1d940379b0d1
md"""*Title, output directory, source are all correct* $(@bind prereqsok CheckBox())"""

# ╔═╡ 29b8ac63-3d57-401f-b99e-97920bf03369
html"""
<br/><br/>
<br/>"""

# ╔═╡ 727a99ac-9106-4bac-a929-e829299f66f5
md""" ## Customizing  the notebook's visual appearance


To learn how to customize the display of texts, check this option: $(@bind seecss CheckBox())
"""

# ╔═╡ 1dfa58d2-bf17-4a6c-af5e-92ac70d34d64
md"""*Use default CSS* $(@bind defaultcss CheckBox(true))"""

# ╔═╡ ab04a33d-07df-4cb3-901b-452eae7ec085
css = if defaultcss
 	cssbody = GreekSyntax.defaultcss()
	 HTML("<style>$(cssbody)</style>")
	 
 else
	 
 html"""
<style>
 div.passage {
 	padding-top: 2em;
 	padding-bottom: 2em;
 
 }
  blockquote.subordination {
 	padding: 0em;
 
 }
  .connector {
 background: yellow;  
 font-style: bold;
}

.subject {
 	text-decoration: underline;
 	text-decoration-thickness: 3px;
}
.object {
 	text-decoration: underline;
 	text-decoration-style: wavy;
 }
 .verb {
 	border: thin solid black;
 	padding: 1px 3px;
 	
 }

 .unassigned {
 color: silver;
 }
 

span.tooltip{
  position: relative;
  display: inline;
}
span.tooltip:hover:after{ visibility: visible; opacity: 0.8; bottom: 20px; }
span.tooltip:hover:before{ visibility: visible; opacity: 0.8; bottom: 14px; }

span.tooltip:after{
  display: block;
  visibility: hidden;
  position: absolute;
  bottom: 0;
  left: 50%;
  opacity: 0.9;
  content: attr(tool-tips);
  height: auto;
  width: auto;
  min-width: 100px;
  padding: 5px 8px;
  z-index: 999;
  color: #fff;
  text-decoration: none;
  text-align: center;
  background: rgba(0,0,0,0.85);
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
  border-radius: 5px;
}
span.tooltip:before {
  position: absolute;
  visibility: hidden;
  width: 0;
  height: 0;
  left: 50%;
  bottom: 0px;
  opacity: 0;
  content: "";
  border-style: solid;
  border-width: 6px 6px 0 6px;
  border-color: rgba(0,0,0,0.85) transparent transparent transparent;
}
 """
 end

# ╔═╡ b4501a23-167e-4095-b9d6-dbd9dafc0d19
md"""*Use default color palette* $(@bind defaultcolors CheckBox(true))"""

# ╔═╡ 7b101134-1c41-40f0-9c1a-16ed9e4e5034
palette = if defaultcolors
	
	GreekSyntax.defaultpalette
	
else
	["#79A6A3;",
	"#E5B36A;",
	"#C7D7CA;",
	"#E7926C;",
	"#D29DC0;",
	"#C2D6C4;",
	"#D291BC;",
	"E7DCCA;",
	"#FEC8D8;",
	"#F5CF89;",
	"#F394AF;"
]
end

# ╔═╡ 7183fd4d-f180-474f-81d5-524aaf7f0152
html"""
<br/><br/><br/><br/><br/><br/><br/><br/><br/>
<hr/>
"""

# ╔═╡ 8176c04e-d8f4-4137-8e6b-89e8bf271b0b


# ╔═╡ 992ff9e8-cdce-4709-beef-9d96a6f668e6
md"""> ## Documentation
> 
> ### How the notebook works
>
> Users should not need to look at any of the following cells in order to annotate the syntax of a citable text, but if you want to understand more about how the notebook works, the following cells include brief documentary text introducing the main computations in the notebook.
>
> Unfold the section *Why is this notebook so complicated?* for a broader discussion
> about the issues in using Pluto as an environment for editing data.
>
"""

# ╔═╡ 2914ad6d-b3e3-42ca-a0b8-31833e51a7e8
md"""> ### Functions to validate prerequisites
>
> We check all user settings before exposing the rest of the notebook.

"""

# ╔═╡ 7aac11cf-3a6b-4a96-8595-81a7a6d6a2a2
"""True if title prerequisite is set."""
function titleok()
	@isdefined(title) && ! isempty(title)
end

# ╔═╡ aaed173a-74da-4e3c-b08c-b2ba49d0d6e3
"""True if srcurl prerequisite is set."""
function srcurlok()
	@isdefined(srcurl) && ! isempty(srcurl)
end

# ╔═╡ 93bee380-1805-49ce-ae9f-794ea2224bb6
"""True if selected data file exists."""
function datafileok()
	@isdefined(datafile) && isfile(joinpath(basedir, datafile)) 
end

# ╔═╡ c8301540-56dc-4785-9d35-2c77d2438a8a
"""True if all prerequisites are defined"""
function prereqs()
	prereqsok && titleok() && isdir(outputdir) && ( srcurlok()  || datafileok())
end

# ╔═╡ 0ce311b0-fcad-4e98-9b1f-42005f44e509
if prereqs()
	md"""### Step 1. Annotate the connection of the sentence to its context."""
end

# ╔═╡ 50250528-afda-4011-87a5-1217169b9b66
md"""> ### Global variables derived from *choice of data set*
>
> - `corpus`: a citable text corpus loaded from the user-supplied URL.
> - `orthotokens`: tokenization of `corpus` using literary Greek orthography
> - `tokencorpus`: derived from `corpus`, and citable at the token level
> - `badortho`: list of all orthographically invalid tokens.  Theyse are found with the `findinvalid` function.
> - `sentencesequence`: a sequence of tuples, each containing a sequence number, and a URN identifying the sentence as a range at the token level


"""

# ╔═╡ d4bf2d09-95de-4f81-ab13-8152e3ba351e
"""Instantiate `OrthographicSystem` for user's menu choice.
"""
function orthography()
	if ortho == "litgreek"
		literaryGreek()
	elseif ortho == "latin23"
		latin23()
	else
		nothing
	end
end

# ╔═╡ 2b3381a1-a82a-441a-81a4-7aa0e62ceac6
corpus = if prereqs()
	if srctype == "url"
		fromcex(srcurl, CitableTextCorpus, UrlReader)
		
	elseif srctype == "file" && datafileok()
		fromcex(joinpath(basedir, datafile), CitableTextCorpus, FileReader)
	end
	
else
	nothing
end

# ╔═╡ 0f38d603-8b1d-451f-8be7-2162e055073f
"""True if corpus loaded successfully."""
function loadedok()
	! isnothing(corpus)
end

# ╔═╡ 41a654d1-44d7-476b-b421-8f83d254f14e
orthotokens = if loadedok()
	tokenize(corpus, orthography());
end

# ╔═╡ 83637e15-cdd7-4dd1-87d1-248bf7f3fcd6
tokencorpus = isnothing(orthotokens) ? nothing : map(orthotokens) do t
	t[1]
end |> CitableTextCorpus

# ╔═╡ c77fb96e-dee1-4207-8e32-a4c07e784bc1
sentencesequence = isnothing(corpus) ? nothing : parsesentences(corpus, orthography())

# ╔═╡ 4627ab0d-42a8-4d92-9b0d-c933b1b41f50
if prereqs()
	md"""

*Choose a sentence to analyze (maximum $(length(sentencesequence)))*: $(@bind sentid NumberField(0:length(sentencesequence)))"""
end

# ╔═╡ 80010946-099e-4e1f-893b-f32aef12783e
"""Compile list of all tokens that are orthographically
invalid in literary Greek orthography.
"""
function findinvalid(c)
	bad = []
	tokens = tokenize(c, orthography());
	for (t,ttype) in tokens
		if ttype isa Orthography.UnanalyzedToken
			push!(bad, t)
		end
	end
	bad
end

# ╔═╡ 3294b863-69ce-46d4-9465-7db4f2a52996
badortho = if loadedok()
	findinvalid(corpus)
end

# ╔═╡ 7ff0baa8-3354-4300-81bc-90466b049e73
if prereqs()
	reportlines = ["**Results**: for *$(title)*, loaded a corpus with  **$(length(corpus))** citable passages, and parsed **$(length(orthotokens))** tokens into **$(length(sentencesequence))** sentences."
]
	
	
	if isempty(badortho)
		push!(reportlines, "All tokens are orthographically valid.")	
	elseif length(badortho) == 1
		push!(reportlines, "**1** token is orthographically invalid.")	
	else
		push!(reportlines, "**$(length(badortho))** tokens are orthographically invalid.")	
	end
	
	Markdown.parse(join(reportlines,"\n"))
end


# ╔═╡ b6cb23ee-8870-41b5-a800-d91d88dc2c28
if prereqs()
	if ! isempty(badortho)
	warning_box(md"""Your text has **$(length(badortho))** orthographically invalid tokens.  This can affect the accuracy of tokenizing and parsing into sentence units.

You can unfold the list below to see a list of invalid tokens.  Consider whether you should correct your source text before annotating it.
""")
end
end


# ╔═╡ c21618ab-7092-4696-9508-8f8efc052917

if prereqs() && ! isempty(badortho)
	ortholines = ["Orthographically invalid tokens:", ""]
	for cp in badortho
		push!(ortholines, string("- ", passagecomponent(cp.urn), ": ", cp.text))
 	end
	orthostr =  join(ortholines, "\n")
	orthomsg = Markdown.parse(orthostr)


	Foldable("See invalid tokens", orthomsg)

end


# ╔═╡ e4c3ab5d-7342-44d6-925b-be6720df8fcf
md"""> ### Global variables derived from the user's *sentence selection*
>
> - `sentence`: the current selection from the `sentencesequence` list
> - `sentenceannotation`. A `SentenceAnnotation` (from the `GreekSyntax` package) for the current sentence. We use the function `connectorurn` in constructing this.
> - `sentencetokens`:  citable tokens for the current sentence. 
> - `sentenceorthotokens`: tokens for the current sentence including classificaiton by token type, as produced by tokenizing with the `Orthography` interface.
 

"""

# ╔═╡ 3a49b461-e4c2-44cb-9600-9ec10bf1e91f
# The currently selected sentence
# Check on existing of sentid!
sentence = if @isdefined(sentid)
	sentid == 0 ? nothing : sentencesequence[sentid]
else
	nothing
end


# ╔═╡ d437d981-8140-49f2-89ef-4a2ddef1cacb
sentencetokens = isnothing(sentence) ? nothing : CitableCorpus.select(sentence.urn, tokencorpus)

# ╔═╡ a050416e-9b64-4103-8859-170d3912339d
if prereqs()
	if sentid == 0
		md""
	else 
		md"""*Choose connecting words from this many initial tokens:* $(@bind ninitial Slider(1:length(sentencetokens), show_value = true, default = 5) )
	"""
	
	end
end

# ╔═╡ 725e9948-db7d-4f45-8954-d8c554185c6e
sentenceorthotokens = begin
	if isnothing(sentence)
		nothing
	else
		rangeindexing = CitableCorpus.indexurn(sentence.urn, tokencorpus)
		orthotokens[rangeindexing[1]:rangeindexing[2]]
	end
end


# ╔═╡ a1412f88-e367-4884-b908-a39926a6cf95
"""Compose a CTS URN for the connecting word or words in a sentence."""
function connectorurn(sentencetokens, connections)
	
		psgref = if length(connections) == 1
			
			sentencetokens[connections[1]].urn |> passagecomponent
			
		else
			openpsg = sentencetokens[connections[1]].urn |> passagecomponent
			closepsg = sentencetokens[connections[end]].urn |> passagecomponent
			string(openpsg,"-", closepsg)
		end
		addpassage(sentencetokens[1].urn, psgref)
		
end

# ╔═╡ d95ddf5b-60db-48c2-9204-2b9d1c8ddca8
md"""> ### User interface for  *sentence selection*
"""

# ╔═╡ d1496b85-c488-4130-a915-aeedfb1e45c0
"""Compose a menu to select the connecting word from the first N tokens of the current sentence.
"""
function connectormenu()
	menu = Pair{Union{Int64,Missing, Nothing}, String}[missing => "", nothing => "asyndeton"]
	idx1 = CitableCorpus.indexurn(sentence.urn, tokencorpus)[1]
	idx2 = idx1 + ninitial - 1
	slice =  orthotokens[idx1:idx2]
	for (i,tkn) in enumerate(slice)
		if tkn[2] != LexicalToken()
			# omit: punctuation
		else
			pr = (i => string(i, ". ", tkn[1].text))
			push!(menu, pr)
		end
	end
	
	menu
end

# ╔═╡ 2a49f12a-88b3-4667-8650-46cd7e127fd9
if prereqs()
	if sentid == 0
		md""	
	else
	md"""*Connecting words*: 

$(@bind connectorlist MultiSelect(connectormenu()))
"""
	end
end

# ╔═╡ a36f18f6-20c8-4d24-9ed3-cf6afd9e0b52
# Make conditional on satisfaction of necessary conditions ...
sentenceannotation = if isnothing(sentence) 
		nothing 
elseif isnothing(connectorlist) || isnothing(connectorlist[1])
	SentenceAnnotation(
		sentence.urn,
		sentence.sequence,
		nothing
	)
else
SentenceAnnotation(
		sentence.urn,
		sentence.sequence,
		connectorurn(sentencetokens, connectorlist)	
	)	
end

# ╔═╡ b3589032-ad92-4dfc-8c0a-62ca4b97d2aa
"""Compose an HTML `blockquote` element setting highlighting on any connector tokens in `tknlist` with an index
appearing in the index list `idxlist`.
"""
function hl_connector(tknlist, idxlist)
	displaylines = ["<blockquote>"]
	for (i, t) in enumerate(tknlist)
		if i in idxlist
			push!(displaylines, " <span class=\"connector\">" * t[1].text *"</span>")
		else
		
			if t[2] isa LexicalToken
				push!(displaylines, " " * t[1].text)
			else
				push!(displaylines, t[1].text)
			end
		end
	end
	push!(displaylines, "</blockquote>")
	
	join(displaylines) 
end

# ╔═╡ b41983f5-8774-4e4b-98fa-58087551971f
if prereqs()
	if ismissing(sentid) || sentid == 0
		md""

	else
		local currpsg = sentence.urn |> passagecomponent
		local str = hl_connector(sentenceorthotokens, connectorlist)
		
		if isempty(connectorlist)
			HTML("<i>Use the following selection box to identify one or more connecting words for this sentence, or select</i> <code>asyndeton</code>:<br/><blockquote><strong>$(currpsg)</strong>: " * str * "</blockquote>")
			
	
			elseif isempty(connectorlist)
			
			HTML("<p><b>Step 1 result:</b></p><blockquote><span class=\"connector\">Asyndeton: no connecting word.</span><br/><strong>$(currpsg)</strong>: " * str * "</blockquote>")
			
		else
			HTML("<p><b>Step 1 result:</b></p><blockquote><strong>$(currpsg)</strong>: " * str * "</blockquote>")
		end
	end
end

# ╔═╡ 97f0be7b-aafc-4180-a2f3-aa43d2c65358
"""True if requirements for sentence-level annotation (step 1) are satisfied"""
function step1()
	if @isdefined(connectorlist) && ! isempty(connectorlist) && isnothing(connectorlist[1])
		# asyndeton
		true
		
	elseif @isdefined(connectorlist) == false || sentid == 0 || isempty(connectorlist) || isnothing(connectorlist[1])
		false
		
	else
		true
	end
end

# ╔═╡ a638caf3-94c9-4a03-8fa4-05d99d8e135a
if step1()
	md"""### Step 2. Define verbal expressions, and groups tokens in verbal expressions"""
else
	md""
end

# ╔═╡ 0e0cd61d-f4d0-4615-a413-4dae483b031b
if step1()
	 local step1res = hl_connector(sentenceorthotokens, connectorlist)
	HTML("<i>Define verbal expressions in this sentence:</i><br/><br/><blockquote><strong>$(passagecomponent(sentenceannotation.range))</strong>: " * step1res * "</blockquote>")

end

# ╔═╡ 031d14de-ce21-4d2c-9b1c-9ddbaf59bb01
# Add display with level indentation
if step1() 
	#=
	if isnothing(assignedtokensdf)
	else
		indentedtext = ["<blockquote class=\"subordination\">"]
		local currindent = 0
		currstring = [""]
		for r in eachrow(assignedtokensdf)
			
			if r.group == 0
				
			else
				## NEED TO CHECK GROUP INFO BY PASSAGE REF ==
				# sentence + group num
				groupref = string(passagecomponent(sentencerange(sentence)),".", r.group)

				ginfo = filter(r -> r.passage == groupref, vudf)
				if nrow(ginfo) != 1
					push!(indentedtext,"""\n\nError with group reference $(groupref)\n\n""")
				else
				
					matchingdepth = ginfo[1,:depth]

				
				if currindent == matchingdepth
					push!(indentedtext, " $(r.token)")
					
				else
					
					if (currindent != 0)
						push!(indentedtext, repeat("</blockquote>", currindent))
					end
					
					push!(indentedtext,  repeat("<blockquote class=\"subordination\">", matchingdepth) * "<strong>$(matchingdepth)</strong>. " * " "  )
					
					currindent = matchingdepth
					push!(indentedtext, " $(r.token)")
				
			
				end
		
					end
			end
		end # for
		push!(indentedtext,"</blockquote>")
		join(indentedtext) |> HTML			
		#indentedtext
	end
	=#
end

# ╔═╡ 4ca90ce5-c1e2-4f35-9e02-81788522c90e
if step1() 
	md"""*Done assigning tokens* $(@bind tokensassigned CheckBox())
	"""  |> aside
else
	md""
end

# ╔═╡ 767f83c3-2c71-4f28-b91f-119d0bd7e243
md"""> ### Global variable derived from the user's *definition of verbal expressions*
>
> - `verbalunits`: vector of `VerbalUnitAnnotations`. We use the function `vusfromdf` to construct this.
"""

# ╔═╡ c9ce7fcc-3d62-4f98-aec7-1d926822af67
"""Create a vector of `VerbalUnitAnnotation`s from the user-edited
data frame `vudataframe`
"""
function vusfromdf(vudataframe)
	
	verbals = VerbalUnitAnnotation[]
	for row in eachrow(vudataframe)
		push!(verbals, VerbalUnitAnnotation(
			row.passage,
			row.syntactic_type,
			row.semantic_type,
			row.depth,
			row.sentence
		))
	end
	verbals
end

# ╔═╡ e48a12b5-d7e8-4981-87da-4516cee27ed0
md"""> ### UI for *defining verbal expressions*
>
> This depends on the trick discussed in the foldable section *Why is this notebooks so complicated?*.

"""

# ╔═╡ 187adacf-badf-482c-976a-9348e60b4c04
"""Create a template DataFrame for recording verbal units"""
function newvudf()
	templatedf = DataFrame(
		syntactic_type = ["Independent clause"], 
		semantic_type = "ADD VALUE HERE", 
		depth = 1
	)
end

# ╔═╡ 6c7b400c-0a73-42f7-93b5-ceb8e7c5960c
vusrcdf = newvudf()

# ╔═╡ 3181e436-9270-48ed-8d15-da8ad9e4927e
let initialize  
	if step1()
	@bind vus editable_table(vusrcdf; filterable=true, pagination=true, height = 300)
	else
		md""
	end
end

# ╔═╡ a906ee9c-dddd-4597-b8bc-6a15ef050138
"""Uses the user edit values for verbal units to create a DataFrame with complete data for verbal units including sentence identifier and correct passage identifier."""
function createvudf()
	spsg =  sentenceannotation.range |> passagecomponent
	nopsg = create_dataframe(vus)

	psg = []
	sem = []
	syn = []
	depths  = []
	sentenceurns = []
	vuidx = 0
	for row in eachrow(nopsg)
		vuidx = vuidx + 1
		push!(psg, string(spsg, ".", vuidx))
		push!(sem, row.semantic_type)
		push!(syn, row.syntactic_type)
		push!(depths, row.depth)
		push!(sentenceurns, sentenceannotation.range)

	end
	DataFrame(
		passage = psg,
		semantic_type = sem,
		syntactic_type = syn,
		depth = depths,
		sentence = sentenceurns
	)
end

# ╔═╡ fedf66bc-7e15-4a4b-8dab-5aec0f07944e
vudf = if step1() && !isnothing(vus)
	createvudf()
else
	nothing
end


# ╔═╡ c775334b-335a-48ad-afa5-9254153bfb3f
verbalunits = if isnothing(vudf)
	nothing
else
	vusfromdf(vudf)
end

# ╔═╡ 63c1e44b-9411-4e78-9cc8-5bebc9148c6d
if ! isnothing(vudf)
	HTML("<p><i>Verbal expressions defined</i>:</p>"  * htmlgrouplist(verbalunits)) |> aside
end

# ╔═╡ 065cecf9-6651-4e55-bae6-70ae6646c427
if ! isnothing(vudf)
	HTML(htmlgrouplist(verbalunits)) |> aside
end

# ╔═╡ f21fd0c4-602c-4782-908c-3dcd91ad936d
"""True if Step 2 editing is complete."""
function step2()
	@isdefined(vusdefined) && vusdefined && step1()
end

# ╔═╡ 699e3b2e-486a-4831-aba2-627dc984b688
md"""> ### Global variables derived from *assigning tokens to verbal expressions*
>
> - `intermediatetokens`. This is a Vector of `TokenAnnotations` for each token in the sentence, but without any assigned syntactic roles yet.
"""

# ╔═╡ ad85c5b0-fae3-4604-acaf-ae03aa41ec2b
md"""> ### UI for *assigning tokens to verbal expressions*
>
> - `tokengroupsdf`: the DataFrame we'll feed to the `PlutoGrid` widget. It has one row ready to edit for each lexical token in the sentence
> - `assignedtokensdf`: the DataFrame with user values, instantiated from the values in a `PlutoGrid` widget
"""

# ╔═╡ 140f25e2-e6b0-47df-a377-c92b3a82c94c
tokengroupssrcdf = if step1()
	local tokentuples = []
	for (tkn, tkntype) in sentenceorthotokens
		if typeof(tkntype) == LexicalToken
			push!(tokentuples, (passage = string(passagecomponent(tkn.urn)), token = string(tkn.text), group = 0))
		end
	end
	DataFrame(tokentuples)
else
	[]
end;

# ╔═╡ 3ae3b338-2e05-4a31-aca3-ebc6b71f3d4c
if step1()
	@bind tokengroups editable_table(tokengroupssrcdf; filterable=true, pagination=true)
else 
	md""
end

# ╔═╡ 14c7b897-8ae7-4f01-94a7-9dfca51ba04f
assignedtokensdf = @isdefined(tokengroups) ? create_dataframe(tokengroups) : nothing ;

# ╔═╡ bfa03c1c-1d93-419d-a3d8-05486bf3bc7e
intermediatetokens = if step1() 
	if isnothing(assignedtokensdf) || nrow(assignedtokensdf) == 0
		nothing
	else
		placeholder = TokenAnnotation[]

		local lexcount = 0
		for t in sentenceorthotokens
			if t[2] isa LexicalToken
				lexcount = lexcount + 1
				row = assignedtokensdf[lexcount, :]
				
				tknurn = addpassage(sentenceannotation.range, row.passage)
				txt = row.token
				vuid = row.group == 0 ? nothing : verbalunits[row.group].id
				push!(placeholder, TokenAnnotation(
				tknurn,
				"lexical",
				txt,
				vuid,
				nothing, nothing, nothing, nothing
				
			))
			else
				push!(placeholder, TokenAnnotation(
					t[1].urn,
					"ignore",
					t[1].text,
					0,
					nothing, nothing, nothing, nothing)
				)
			end
		end

		placeholder
	end
end

# ╔═╡ d10e1b6d-c6ac-4bc3-a44b-01f9837a520e
# ╠═╡ show_logs = false
if isnothing(intermediatetokens)
else
htmltext_indented(sentenceannotation, verbalunits, intermediatetokens, vucolor = false)  |> HTML
end

# ╔═╡ 79b09a32-2bcf-410a-b5e0-1fa0f6aeb943
if isnothing(intermediatetokens)
else
 "<blockquote>" * htmltext(sentenceannotation, intermediatetokens) * "</blockquote>" |> HTML

end

# ╔═╡ 0c9bef6a-2b7c-43bb-b873-e9f63923c78f
isnothing(assignedtokensdf) ? md"`assignedtokensdf` undefined" : describe(assignedtokensdf)

# ╔═╡ 9cca16b6-2018-4770-b774-c54bc73f65d2
md"""> ### Global variables for *defining syntactic relations*
>
> - `syntaxannotations` The final Vector of `TokenAnnotation`s
"""

# ╔═╡ 2cb8958b-458d-4c19-af56-1de1905bb62f
md"""> ### UI for *defining syntactic relations*
>
> - `syntaxsrcdf`: the DataFrame we'll feed to the PlutoGrid widget. It has one row ready to edit for each lexical token in the sentence.
> - `syntax`: the DataFram with user edited values.
"""

# ╔═╡ 1f9b98d9-a7e0-43bf-a651-5e2e3afc85cf
syntaxsrcdf = if isnothing(intermediatetokens)
	nothing
else
	syntaxtuples = []
	lexcount = 0
	for  t in intermediatetokens
		if t.tokentype == "lexical"
			lexcount = lexcount + 1
			tupl = (
			passage = string(passagecomponent(t.urn)),
			reference = lexcount,
			token = t.text,
			node1 = missing, node1rel = missing, 
			node2 = missing, node2rel = missing
			)
			push!(syntaxtuples, tupl)
		end
	end

	#=
	if isempty(connectorlist) || isnothing(connectorlist[1])
		psg = sentencerange(sentence) |> passagecomponent
		deranged = replace(psg, "-" => "_")
		extrarow = (passage = string( "_asyndeton_",deranged), reference = seq + 1, token = "asyndeton", node1 = missing, node1rel = missing, node2 = missing, node2rel = missing)
		push!(syntaxstrings, extrarow)
	end
		=#
	syntaxtuples |> DataFrame

end;

# ╔═╡ 68d9874a-d106-4fbc-8935-82e80cc92f9f
"""True if Step 3 editing is complete."""
function step3()
	step1() && tokensassigned
end

# ╔═╡ 7d418f4f-ffb5-4048-8dd2-8535c6d5f664
if step3()
		#HTML("""<p><b>Step 2 results</b><br/><blockquote>
#$(formatsentence(sentence))</blockquote></p>
#	""")
end

# ╔═╡ 5d167ed1-905c-44bd-8b7d-e174f4a0eb04
if step3()
	md"""### Step 3. Define syntactic relations"""
else
	md""
end

# ╔═╡ a4a599ce-6362-4b57-a359-0ee1e8d12006
if step3() 
	HTML("""<h4>Edit syntactic relations</h4>

	""")
end

# ╔═╡ fafa2505-fe2c-4a46-9e43-a54f44e9522f
if step3()
	if nrow(vudf) == 0
	md""
else
	syntaxtips = [ "##","",
		"**Organization of verbal units**",
		"",
		"- conjunction",
		"- connector",
		"- unit verb",
		"",
	"**Subordination**","",
	"- conjunction",
"- subordinate conjunction",
"- relative",
"- indirect statement",
"- quoted",
"- indirect statement with infinitive",
"- indirect statement with participle",
"- articular infinitive",
"- circumstantial participle",
"- attributive participle",
"",
	"**Relations to `unit verb`**",
"",

"- subject",
"- object",
"- adverbial",
"- dative",
"- direct address",
"- modal particle",
		"- complementary infinitive",
		"- supplementary participle",
	"",
	"**Relations to substantives**",
"",
"- attribute",
"- article",
"- pronoun",
"",
	"**Relations to prepositions**",
"- object of preposition"
	]
	syntaxtipstr = join(syntaxtips, "\n")
	Foldable("See cheat sheet for syntactic relations",aside(Markdown.parse(syntaxtipstr))) |> aside
end
	else
		md""
	end

# ╔═╡ 69451dde-a999-4c1f-a8e4-ed731e282149
if step3()
	@bind syntaxdf editable_table(syntaxsrcdf; filterable=true, pagination=true)
else
	md""
end

# ╔═╡ ca48466c-cd85-456e-ac50-072490cdbc8b
syntax = @isdefined(syntaxdf) ? create_dataframe(syntaxdf) : nothing;

# ╔═╡ fa2e20e9-0f7a-4cca-b611-cda26051bce6

# Check on intermediatetokens, AND syntax
syntaxannotations = if isnothing(syntax) || isnothing(intermediatetokens)
	nothing
	
else
	newtokens = TokenAnnotation[]
#filter(row -> row.sex == "male", df)
	for tkn in intermediatetokens
		dfmatches = filter(row -> row.passage == passagecomponent(tkn.urn), syntax)
		if nrow(dfmatches) == 1
			newta = TokenAnnotation(
				tkn.urn,
				tkn.tokentype,
				tkn.text,
				tkn.verbalunit,
				dfmatches[1, :node1],
				dfmatches[1, :node1rel],
				dfmatches[1, :node2],
				dfmatches[1, :node2rel]
			
			)
			push!(newtokens, newta)
		else
			push!(newtokens, tkn)
		end
	end
	newtokens
end

# ╔═╡ fe16ab5c-9065-4518-8ac3-38e3506d7633
if step3()
	graphstr = mermaiddiagram(sentenceannotation, syntaxannotations)
	mermaid"""$(graphstr)"""

	
else 
	md""
end

# ╔═╡ 5116aaa6-af7c-46e7-9e11-6059e587f5c0

md"""> ### File management
>
> 
>

"""


# ╔═╡ d86eca56-ea1f-4d32-bff2-44f26d12e3f4
mkpath(outputdir);

# ╔═╡ 013963bc-d65f-449f-8bd5-ddda9dddb1fd
fname = replace(title, " " => "_");

# ╔═╡ db3c92ef-9cab-4adf-b128-3f3e7eda885d
if step3()
	
	md"""### Step 4. Save final results
	
*Save to file named* $(fname).cex $(@bind saves CounterButton("Save file"))
"""
end

# ╔═╡ 55394f6e-e696-4f44-a00e-1dd6e4fcdcb8
outputfile = joinpath(outputdir, fname * ".cex");

# ╔═╡ 86da97f3-bb20-4779-8efa-b9088409acd6
"""Append delimited-text representation of annotations to file `filename`.
"""
function appendannotations(filename, sents, vus, tkns; delimiter = "|")
	hdrlines = isfile(filename) ? readlines(filename) : []
	push!(hdrlines, "")
	push!(hdrlines, "//")
	push!(hdrlines, "// Automatically appended from Pluto notebook \"Analyze syntax of Greek text from a CTS source\" (version $(nbversion))")
	push!(hdrlines, "//")

	txt = join(hdrlines, "\n") * "\n#!sentences\n" * delimited(sents) * "\n\n#!verbal_units\n" * delimited(vus) * "\n\n#!tokens\n" * delimited(tkns)	

	
end

# ╔═╡ c205e757-4e5a-4b22-ac53-bdad947a942c
if step3()
	if saves > 0
		
		txt = appendannotations(outputfile, [sentenceannotation], verbalunits, syntaxannotations; delimiter = "|")
	
		
		open(outputfile, "w") do io
			write(io, txt)
		end
		tip(md"""Appended data for **sentence $(sentid)** to file $(outputfile).
		""") 
		
	end
end

# ╔═╡ 36a67acb-e449-489d-a548-bd5761f1321c
md"""> ### Settings for visual formatting"""

# ╔═╡ ab5048e0-e1c4-42ec-8837-a16dd231fe37
"""Format user instructions with Markdown admonition."""
instructions(title, text) = Markdown.MD(Markdown.Admonition("tip", title, [text]))

# ╔═╡ 3487cd67-8c0f-4fe0-8c3a-2d25bba023bd
begin
	overview = md"""
This notebook allows you to annotate the syntax of a citable Greek text, and save your annotations to simple delimited text files.

Begin by identifying a CEX source for a citable text to load.  The notebook parses the text into tokenized sentences: syntactic annotations are based on analyzing one sentence at a time.

Choose a sentence to annotate.  The notebook will prompt you, following the model [documented here](https://neelsmith.github.io/GreekSyntax/). The main steps are: 

1. Annotate the [connection of the sentence to its context](https://neelsmith.github.io/GreekSyntax/modelling/sentences/).
2. Identify the sentence's [verbal expressions](https://neelsmith.github.io/GreekSyntax/modelling/verbal_units/), and assign tokens in the sentence to the appropriate verbal expression.
3. Annotate the syntactic relation of tokens (see [https://neelsmith.github.io/GreekSyntax/modelling/tokens/](https://neelsmith.github.io/GreekSyntax/modelling/tokens/) and [https://neelsmith.github.io/GreekSyntax/modelling/syntax/](https://neelsmith.github.io/GreekSyntax/modelling/syntax/)).


When you have completely annotated a sentence, you can save the results to a delimited-text file.  If the file already exists, the new content will be appended to the file, so you can use a single file as you work through multiple sentences.
"""
	Foldable("What this notebook does", instructions("Overview of analyzing syntax", overview)) 
end


# ╔═╡ e5caf28b-6ace-4b85-afb6-8406b9c062ed
begin
	tipsmd = md"""

- As you complete each step of annotating a sentence, the next step is presented to you.
- In the right hand column, you'll find notes to help you.  Use the dark triangle to unfold a help section.
- A table of contents is pinned to the top right of notebook. This can be useful as your notebook grows in length.  For example, if you save your annotatoins for a sentence, and want to continue with a new sentence, you can use the table of contents to jump directly to the section headed *Annotate the connection of the sentence to its context*.  You can hide the table of contents if it gets in your way.
"""
	Foldable("A few tips for navigating this notebook", instructions("Tips for navigating the notebook", tipsmd)) 
end

# ╔═╡ 910b86a4-b801-4a7a-bab7-9ad072e75bc3
begin
	loadmsg = md"""

Provide values for the following three input boxes:
	
1. Define a directory for saving results of your annotations. If you enter a directory that does not yet exist, the notebook will attempt to create it.
1. Paste or type a URL for a CEX source for a citable text into the second input box.
2. In the third input box, enter a title to use in formatting text and saving your annotations in local files.

For each input box, use the `Submit` button to verify your entry.  When you have verified all three input boxes, check `Output directory, source URL and title are all correct`.

It may take a moment for the notebook to download and parse your file.

"""
	Foldable("How to load texts to analyze", instructions("Loading files", loadmsg)) |> aside
end


# ╔═╡ 49169dec-8a82-406b-a1cc-8efaa940efea
begin
orthodetails = md"""


**Greek**: 

- *literary orthography*: texts in the standard orthography of printed editions of ancient Greek texts
- *epichoric Attic*: NOT CURRENTLY AVAILABLE


**Latin**:

- *23-character alphabet*: alphabet uses *i* and *u* for both consonantal and vocalic values
- *24-character alphabet*: alphabet distinguishes vocalic *u* from consonantal *v*, uses *i* for both consonantal and vocalic values
- *25-character alphabet*: alphabet distinguishes vocalic *u* and *i* from consonantal *v* and *j*, respectively

"""

Foldable("Details about language and orthography", instructions("Available choices of language and orthography", orthodetails))
end

# ╔═╡ 336f2a45-45b1-4381-88af-e35a703574fb
if prereqs()
	msg1 = md"""
1. Choose a sentence.
2. From the list labelled *Connecting words*, identify one or more connecting words (conjunction, particles) that connect the sentence to its broader context, or choose `asyndeton` if there is none.
	"""


		Foldable("Step 1 instructions", instructions("Annotating a sentence", msg1)) |> aside

end

# ╔═╡ b8ab34a6-2336-471c-bb74-6ad0800ba22d
if step1()
	msg2 = md"""	

In this step, you will work with two data entry  tables.
	
1. In the first table, complete a row for each verbal expression.
1. In the second table, fill in the verbal expression's sequential number to group each token belonging to it. Any connecting words you identified in Step 1 should be left as verbal expression *0*. 


When you have associated each token with the correct verbal expression, check the box `Done assigning tokens` (at the end of the second table).

	
	"""

	Foldable("Step 2 instructions", instructions("Defining verbal units", msg2)) |> aside
	
end

# ╔═╡ ec6d4eb1-32dc-4dc5-82ab-eafba0540da8
if step3()
	msg4 = md"""Associate each token with a token it depends on, and define their relation.  If the token is a conjunction or a relative clause, you should also 
	associate it with a second token and define that relation, too.

	Unfold the cheat sheet below to see a list of valid tags for relations.
	"""
	Foldable("Step 3 instructions",
	instructions("Assigning tokens to verbal units", msg4)) |> aside
else
	md""
end

# ╔═╡ 82e1af58-81b6-4f01-984c-63d95be4f4f3
begin
	if seecss
	cssmsg = md"""
The following two cells define the visual appearance of the text's formatting.  If you are familiar with CSS, you can modify them to tailor the presentation to your preferences.

1.  You can choose to use default CSS from the `GreekSyntax` package, or directly edit CSS values from the following cell.
2. `palette` is a series of colors that the notebook cycles through in highlighting different verbal expressions by color.	You can use a default color palette from `GreekSyntax`, or directly edit the cell to set RGB values.
"""
		instructions("Style your own", cssmsg)
	end
end

# ╔═╡ 423ff985-22e9-4aa8-a090-922448d53f4d
begin
	whysocomplicated = md"""	

Because it's fundamentally at odds with what Pluto is all about!

#### Pluto is stateless

- this makes reactivity possible
- cells have a value
- you can't reassign variables

#### Interactive widgets

- wrap a javascript widget in Pluto so cell returns value of widget
- mutable value lives in the DOM only

#### Editing a table
	
- lungben's widget  [PlutoGrid](https://github.com/lungben/PlutoGrid.jl) lets you edit a DataFrame.  You start from a source data frame
- the widget returns a stream of data that you can use to create a new DataFrame with the edited values.  Now any other cell has access to the second DataFrame with edited values.

	"""

	Foldable("Why is this notebook so complicated?", instructions("Using Pluto as for editing data", whysocomplicated)) 
end


# ╔═╡ d1eca415-05cb-435a-8f64-aad583a56d43
md"""> ### What's all this?
"""

# ╔═╡ 7bc296a5-d4ee-4a60-be7c-20df3a121176
"""Find index of a single node with token value `asyndeton`"""
function asyndetonidx(syndf)
	#filter(row -> row.sex == "male", df)
	asynmatches = filter(row -> row.token == "asyndeton", syndf)
	nrow(asynmatches) == 1 ? asynmatches[1,:reference] : nothing
end;
	

# ╔═╡ Cell order:
# ╟─d345d44b-a9ed-4d70-a470-1f1cb53a18a9
# ╟─31cc3ad6-ac34-49f7-a86f-575a08eb1358
# ╟─2009a8a2-7f18-11ed-32f5-2d0ae7ffdde8
# ╟─ed67e569-147c-4899-b338-f3282d9474b1
# ╟─d227b2f4-5cdd-4ef6-ae7c-0a8f02f1f966
# ╟─44a1635c-41af-450e-b06e-670367ae489b
# ╟─3487cd67-8c0f-4fe0-8c3a-2d25bba023bd
# ╟─e5caf28b-6ace-4b85-afb6-8406b9c062ed
# ╟─d865bcd7-ef34-48d1-9526-623578822e42
# ╟─910b86a4-b801-4a7a-bab7-9ad072e75bc3
# ╟─ccb5e655-9bb1-4117-9231-f9a90855b48b
# ╟─3c3003e6-ebe9-434a-8960-6504b0e1578e
# ╟─a6a283db-692c-43ff-8c43-6038d3bc2ed2
# ╟─9d8b4b7c-f6f6-4f53-9f08-0854069f658b
# ╟─de0e1c93-4e9a-40da-bf76-b9952d2da2ae
# ╟─2d13c642-7c89-4e47-bad0-0a5ff98e1d8d
# ╟─49169dec-8a82-406b-a1cc-8efaa940efea
# ╟─73cb1d9d-c265-46c5-ae8d-1d940379b0d1
# ╟─7ff0baa8-3354-4300-81bc-90466b049e73
# ╟─b6cb23ee-8870-41b5-a800-d91d88dc2c28
# ╟─c21618ab-7092-4696-9508-8f8efc052917
# ╟─0ce311b0-fcad-4e98-9b1f-42005f44e509
# ╟─336f2a45-45b1-4381-88af-e35a703574fb
# ╟─4627ab0d-42a8-4d92-9b0d-c933b1b41f50
# ╟─a050416e-9b64-4103-8859-170d3912339d
# ╟─b41983f5-8774-4e4b-98fa-58087551971f
# ╟─2a49f12a-88b3-4667-8650-46cd7e127fd9
# ╟─a638caf3-94c9-4a03-8fa4-05d99d8e135a
# ╟─b8ab34a6-2336-471c-bb74-6ad0800ba22d
# ╟─0e0cd61d-f4d0-4615-a413-4dae483b031b
# ╟─63c1e44b-9411-4e78-9cc8-5bebc9148c6d
# ╟─3181e436-9270-48ed-8d15-da8ad9e4927e
# ╟─d10e1b6d-c6ac-4bc3-a44b-01f9837a520e
# ╟─065cecf9-6651-4e55-bae6-70ae6646c427
# ╟─79b09a32-2bcf-410a-b5e0-1fa0f6aeb943
# ╟─3ae3b338-2e05-4a31-aca3-ebc6b71f3d4c
# ╟─031d14de-ce21-4d2c-9b1c-9ddbaf59bb01
# ╟─4ca90ce5-c1e2-4f35-9e02-81788522c90e
# ╟─7d418f4f-ffb5-4048-8dd2-8535c6d5f664
# ╟─5d167ed1-905c-44bd-8b7d-e174f4a0eb04
# ╟─ec6d4eb1-32dc-4dc5-82ab-eafba0540da8
# ╟─fe16ab5c-9065-4518-8ac3-38e3506d7633
# ╟─a4a599ce-6362-4b57-a359-0ee1e8d12006
# ╟─fafa2505-fe2c-4a46-9e43-a54f44e9522f
# ╟─69451dde-a999-4c1f-a8e4-ed731e282149
# ╟─db3c92ef-9cab-4adf-b128-3f3e7eda885d
# ╟─c205e757-4e5a-4b22-ac53-bdad947a942c
# ╟─29b8ac63-3d57-401f-b99e-97920bf03369
# ╟─727a99ac-9106-4bac-a929-e829299f66f5
# ╟─82e1af58-81b6-4f01-984c-63d95be4f4f3
# ╟─1dfa58d2-bf17-4a6c-af5e-92ac70d34d64
# ╟─ab04a33d-07df-4cb3-901b-452eae7ec085
# ╟─b4501a23-167e-4095-b9d6-dbd9dafc0d19
# ╟─7b101134-1c41-40f0-9c1a-16ed9e4e5034
# ╟─7183fd4d-f180-474f-81d5-524aaf7f0152
# ╟─8176c04e-d8f4-4137-8e6b-89e8bf271b0b
# ╟─992ff9e8-cdce-4709-beef-9d96a6f668e6
# ╟─423ff985-22e9-4aa8-a090-922448d53f4d
# ╟─2914ad6d-b3e3-42ca-a0b8-31833e51a7e8
# ╟─c8301540-56dc-4785-9d35-2c77d2438a8a
# ╟─7aac11cf-3a6b-4a96-8595-81a7a6d6a2a2
# ╟─aaed173a-74da-4e3c-b08c-b2ba49d0d6e3
# ╟─93bee380-1805-49ce-ae9f-794ea2224bb6
# ╟─0f38d603-8b1d-451f-8be7-2162e055073f
# ╟─50250528-afda-4011-87a5-1217169b9b66
# ╟─d4bf2d09-95de-4f81-ab13-8152e3ba351e
# ╟─2b3381a1-a82a-441a-81a4-7aa0e62ceac6
# ╟─41a654d1-44d7-476b-b421-8f83d254f14e
# ╟─83637e15-cdd7-4dd1-87d1-248bf7f3fcd6
# ╟─3294b863-69ce-46d4-9465-7db4f2a52996
# ╟─c77fb96e-dee1-4207-8e32-a4c07e784bc1
# ╟─80010946-099e-4e1f-893b-f32aef12783e
# ╟─e4c3ab5d-7342-44d6-925b-be6720df8fcf
# ╟─3a49b461-e4c2-44cb-9600-9ec10bf1e91f
# ╟─a36f18f6-20c8-4d24-9ed3-cf6afd9e0b52
# ╟─d437d981-8140-49f2-89ef-4a2ddef1cacb
# ╟─725e9948-db7d-4f45-8954-d8c554185c6e
# ╟─a1412f88-e367-4884-b908-a39926a6cf95
# ╟─d95ddf5b-60db-48c2-9204-2b9d1c8ddca8
# ╟─d1496b85-c488-4130-a915-aeedfb1e45c0
# ╟─b3589032-ad92-4dfc-8c0a-62ca4b97d2aa
# ╟─97f0be7b-aafc-4180-a2f3-aa43d2c65358
# ╟─767f83c3-2c71-4f28-b91f-119d0bd7e243
# ╠═c775334b-335a-48ad-afa5-9254153bfb3f
# ╟─c9ce7fcc-3d62-4f98-aec7-1d926822af67
# ╟─e48a12b5-d7e8-4981-87da-4516cee27ed0
# ╟─6c7b400c-0a73-42f7-93b5-ceb8e7c5960c
# ╟─fedf66bc-7e15-4a4b-8dab-5aec0f07944e
# ╟─187adacf-badf-482c-976a-9348e60b4c04
# ╟─a906ee9c-dddd-4597-b8bc-6a15ef050138
# ╟─f21fd0c4-602c-4782-908c-3dcd91ad936d
# ╟─699e3b2e-486a-4831-aba2-627dc984b688
# ╟─bfa03c1c-1d93-419d-a3d8-05486bf3bc7e
# ╟─ad85c5b0-fae3-4604-acaf-ae03aa41ec2b
# ╠═140f25e2-e6b0-47df-a377-c92b3a82c94c
# ╠═14c7b897-8ae7-4f01-94a7-9dfca51ba04f
# ╟─0c9bef6a-2b7c-43bb-b873-e9f63923c78f
# ╟─9cca16b6-2018-4770-b774-c54bc73f65d2
# ╟─fa2e20e9-0f7a-4cca-b611-cda26051bce6
# ╟─2cb8958b-458d-4c19-af56-1de1905bb62f
# ╠═ca48466c-cd85-456e-ac50-072490cdbc8b
# ╠═1f9b98d9-a7e0-43bf-a651-5e2e3afc85cf
# ╟─68d9874a-d106-4fbc-8935-82e80cc92f9f
# ╟─5116aaa6-af7c-46e7-9e11-6059e587f5c0
# ╠═d86eca56-ea1f-4d32-bff2-44f26d12e3f4
# ╠═013963bc-d65f-449f-8bd5-ddda9dddb1fd
# ╠═55394f6e-e696-4f44-a00e-1dd6e4fcdcb8
# ╟─86da97f3-bb20-4779-8efa-b9088409acd6
# ╟─36a67acb-e449-489d-a548-bd5761f1321c
# ╟─ab5048e0-e1c4-42ec-8837-a16dd231fe37
# ╟─d1eca415-05cb-435a-8f64-aad583a56d43
# ╠═7bc296a5-d4ee-4a60-be7c-20df3a121176
