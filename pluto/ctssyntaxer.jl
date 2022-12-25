### A Pluto.jl notebook ###
# v0.19.17

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
nbversion = "0.1.1";

# ╔═╡ 9c197585-a2dd-42d2-b45c-deb5f756434b
begin
	tbdmd = md"""At the bottom of this notebook is a section of documentation you can unhide.

Note that in notebook version **$(nbversion)**, *this documentation has not yet been updated*.  Please look for a subsequent release of this notebook for better documentation.
"""
	warning_box(tbdmd)
end

# ╔═╡ ed67e569-147c-4899-b338-f3282d9474b1
md"""(*Notebook version **$(nbversion)**.*)  *See version history* $(@bind history CheckBox())"""

# ╔═╡ d227b2f4-5cdd-4ef6-ae7c-0a8f02f1f966
if history
md"""

- **0.1.1**: bug fixes, including important correction to sentence + group ID in export of token annotations.
- **0.1.0** initial version:  load a citable corpus from CEX source, validate its orthography and parse into sentence units citable by CTS URN, save annotation results to delimited-text files.
"""
else
		md""
	
	
end

# ╔═╡ 44a1635c-41af-450e-b06e-670367ae489b
md"""


## Analyze syntax of Greek text from a CTS source

> *Annotate the syntax of a citable Greek text, and save your annotations to simple delimited text files.*


"""

# ╔═╡ d865bcd7-ef34-48d1-9526-623578822e42
md"""### Prerequisites: configuring your notebook"""

# ╔═╡ 3c3003e6-ebe9-434a-8960-6504b0e1578e
begin
	defaultdir = joinpath(pwd(), "output")
	md"""*Directory where results will be saved*: $(@bind outputdir confirm(TextField(80, default = defaultdir)))"""
# *Title*: $(@bind title TextField(80; placeholder = "Title for text"))
end

# ╔═╡ b092c825-d4f8-4f3d-a8b1-57a6a642290d
md"""
*Paste or type in a URL for the CEX source file to annotate.*
 $(@bind srcurl confirm(TextField(80; placeholder = "URL for CEX source")))

	"""

# ╔═╡ 58b8e896-1d55-4d43-8d93-d9421f1d85bf
if isempty(srcurl)
	nourl_prompt = md"""Please paste or type in a URL for the CEX source of the text you want to annotate in the input box below.
	
	If you want to practice by annotating Lysias 1, you can use [https://raw.githubusercontent.com/neelsmith/GreekSyntax/main/sandbox/lysias1.cex](https://raw.githubusercontent.com/neelsmith/GreekSyntax/main/sandbox/lysias1.cex)."""
	still_missing(nourl_prompt)
end

# ╔═╡ ccb5e655-9bb1-4117-9231-f9a90855b48b
md"""*Please provide a title for your collection of annotations.*

*Title*: $(@bind title confirm(TextField(80; placeholder = "Title for text")))
"""


# ╔═╡ 73cb1d9d-c265-46c5-ae8d-1d940379b0d1
md"""*URL and title are correct* $(@bind urlok CheckBox())"""

# ╔═╡ 7183fd4d-f180-474f-81d5-524aaf7f0152
html"""
<br/><br/><br/><br/><br/><br/><br/><br/><br/>
<hr/>
"""

# ╔═╡ 736baf25-214a-4d22-9003-a4d33155b36e
md"""> **Under the hood**
>
*Check this box to see how this notebook works*  $(@bind openhood CheckBox(true))
"""

# ╔═╡ ae140e63-0e4d-4978-b6c2-9f135cac8163
if openhood
	md"""> ### Prerequisites documentation: loading and formatting data: NEEDS UPDATING
>
>The following hidden cells ... do a lot of work. **TBA**
>
> Unhide them to see details.	
"""
else
	md""
end

# ╔═╡ 2b3381a1-a82a-441a-81a4-7aa0e62ceac6
corpus = if urlok && ! isempty(srcurl)
	fromcex(srcurl, CitableTextCorpus, UrlReader);
else
	nothing
end;

# ╔═╡ 0f38d603-8b1d-451f-8be7-2162e055073f
"""True if corpus loaded successfully."""
function loadedok()
	! isnothing(corpus)
end;

# ╔═╡ 47c1d979-f814-404d-80b1-adf3fcd1d337
"""True if prereqs satisfied."""
function prereqsok()
	isempty(title) ? false : loadedok()
end;

# ╔═╡ 0ce311b0-fcad-4e98-9b1f-42005f44e509
if prereqsok()
	md"""### Step 1. Annotate the connection of the sentence to its context."""
end

# ╔═╡ 41a654d1-44d7-476b-b421-8f83d254f14e
tokens = if prereqsok()
	tokenize(corpus, literaryGreek());
end;

# ╔═╡ 80010946-099e-4e1f-893b-f32aef12783e
function findinvalid(c)
	bad = []
	tokens = tokenize(c, literaryGreek());
	for (t,ttype) in tokens
		if ttype isa Orthography.UnanalyzedToken
			push!(bad, t)
		end
	end
	bad
end;

# ╔═╡ 3294b863-69ce-46d4-9465-7db4f2a52996
badortho = if prereqsok()
	findinvalid(corpus)
end;

# ╔═╡ b6cb23ee-8870-41b5-a800-d91d88dc2c28
if prereqsok()
	if ! isempty(badortho)
	warning_box(md"""Your text has **$(length(badortho))** orthographically invalid tokens.  This can affect the accuracy of tokenizing and parsing into sentence units.

You can unfold the list below to see a list of invalid tokens.  Consider whether you should correct your source text before annotating it.
""")
end
end

# ╔═╡ c21618ab-7092-4696-9508-8f8efc052917
if prereqsok() && ! isempty(badortho)
	ortholines = ["Orthographically invalid tokens:", ""]
	for cp in badortho
		push!(ortholines, string("- ", passagecomponent(cp.urn), ": ", cp.text))
 	end
	orthostr =  join(ortholines, "\n")
	orthomsg = Markdown.parse(orthostr)


	Foldable("See invalid tokens", orthomsg)

end

# ╔═╡ a8e032a5-94f8-4937-aad1-016883116f85
"""Break up corpus `c` into sentence units.
"""
function parsesentences(c)
	tokens = tokenize(c, literaryGreek());
	baseurn = c.passages[1].urn |> droppassage
	finals = [".", ":", ";"]
	rangeopener = ""

	sentenceurls = []
	sentencecontents = []
	currentsentence = []	
	for n in tokens
    	if n[1].text in finals
        	rangeu = addpassage(baseurn, string(rangeopener, "-", 	passagecomponent(n[1].urn)))
	        push!(sentenceurls, rangeu)

			push!(currentsentence, n)
			push!(sentencecontents, currentsentence)
			currentsentence = []
			
	    else
			if isempty(rangeopener)
	        	rangeopener = passagecomponent(n[1].urn)
	    	end
			push!(currentsentence, n)
		end
	end
	(sentenceurls,sentencecontents)
end;

# ╔═╡ 9ad3cf28-d403-449e-a8db-cc8a5fe84bee
if loadedok() 
	(urnlist, sentences) = parsesentences(corpus);
end;

# ╔═╡ 7ff0baa8-3354-4300-81bc-90466b049e73
if prereqsok()
	reportlines = ["**Results**: for *$(title)*, loaded corpus with  **$(length(corpus))** citable passages, and parsed **$(length(tokens))** tokens into **$(length(sentences))** sentences."
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

# ╔═╡ 4627ab0d-42a8-4d92-9b0d-c933b1b41f50
if prereqsok()
	md"""

*Choose a sentence to analyze*: $(@bind sentid NumberField(0:length(sentences)))"""
end

# ╔═╡ b5be20e7-4eec-405b-9aa6-dfbd6aedbecd
if openhood
	md"""> ### Step 1 documentation: annotating a sentence: NEEDS UPDATING
> Summary of the following three hidden cells: **TBA**
>
> 1. Defines a global variable `sentence` that is selected from the `sentences` vector based on the user's choice of sentence number.
> 2. Defines a function `connectormenu` to compose a menu for choosing the token connecting the selected sentence to its broader context.
> 3. Defines a function `step1` that is true if step 1 annotation is complete.
>
> Unhide them to see details.
"""
else
	md""
end

# ╔═╡ 3a49b461-e4c2-44cb-9600-9ec10bf1e91f
# The currently selected sentence
if prereqsok()
	sentence = sentid == 0 ? [] : sentences[sentid];
end;

# ╔═╡ a050416e-9b64-4103-8859-170d3912339d
if prereqsok()
	if sentid == 0
		md""
	else 
		md"""*Choose a connecting word from this many initial tokens:* $(@bind ninitial Slider(1:length(sentence), show_value = true, default = 10) )
	"""
	
	end
end

# ╔═╡ 15deb4e6-4d84-4862-b453-d33cb96a02c7
"""Find CTS URN for range of tokens in sentence `s`."""
function sentencerange(s)
	baseurn = droppassage(s[1][1].urn)
	opener = passagecomponent(s[1][1].urn)
	closer = passagecomponent(s[end][1].urn)
	addpassage(baseurn, string(opener, "-", closer))
end;

# ╔═╡ d193df28-4805-49f7-a5ea-c2885be9cd98
if openhood
md"""> ### Step 2 documentation. Define verbal units: NEEDS UPDATING
>
> The next three hidden cells manage creating and editing a DataFrame defining the verbal units in the current sentene.
>
> 1. The first cell defines a function that returns a DataFrame with a single row for an independent clause. This is used to initialize the editing widget in the UI above using [PlutoGrid](https://github.com/lungben/PlutoGrid.jl).
> 2. The second cell invokes this function to define a DataFrame `vusrcdf`.
> 3. The third clause instantiates a DataFrame `vudf` from the edited values in the editing widget. This is how other cells can access edited values, since the source DataFrame is unmodified by the editing widget.
> 4. Defines a function `step2` that is true if step 2 editing is complete.
>
> Unhide them to see details.

"""
else
	md""
end

# ╔═╡ 86264609-3fb6-479b-9289-35bb31e7999b
function typelabel(tkntype)
	if string(typeof(tkntype)) == "Orthography.LexicalToken"
		"lexical"
	elseif string(typeof(tkntype)) == "Orthography.PunctuationToken"
		"punctuation"
	elseif string(typeof(tkntype)) == "Orthography.UnanalyzedToken"
		"unanalyzed"
	else
		"unrecognized"
	end
end;

# ╔═╡ 187adacf-badf-482c-976a-9348e60b4c04
"""Define a DataFrame for recording verbal units"""
function newvudf()
	templatedf = DataFrame(syntactic_type = ["Independent clause"], semantic_type = "ADD VALUE HERE", depth = 1)
end;

# ╔═╡ 6c7b400c-0a73-42f7-93b5-ceb8e7c5960c
vusrcdf = newvudf();

# ╔═╡ 86b59bc9-0cbb-4913-a67e-23f19fcd73a4
if openhood
md"""> ### Step 3 documentation. Assign tokens to verbal units
>
> The following four hidden cells manage assinging tokens to verbal units
> defined in step 2.
>
> 1. Creates `tokenlist`, a list with a `NamedTuple` for each token. This is an easy way to define names and types to construct a DataFrame.
> 2. Creates a DataFrame named `tokengroupsdf` from `tokenlist`. This is used above to initialize an `PlutoGrid` editing widget.
> 3. Instantiates a DataFrame `assignedtokensdf` from the edited values.
> 4. Defines a function `step3` that is true if step 3 editing is complete.
>
> Unhide them to see details.
"""
else
	md""
end

# ╔═╡ 7b206be8-19cc-49b4-98a9-b39177701f2b
"""Look up in dataframe `df` the assigned group for passage `psg`."""
function groupforpassage(psg, df)
	psgmatches = filter(row -> row.passage == psg, df)
	groupid = nrow(psgmatches) == 1 ? psgmatches[1, :group] : nothing
	string(passagecomponent(sentencerange(sentence)), ".", groupid)
end;

# ╔═╡ 419c6fe4-b41f-4045-a2d2-c14a9b255f35
if openhood
md"""> ### Step 4 documentation. Annotate syntax NEEDS UPDATING
>
> The following hidden cells manage the dataframe for annotating syntax.
>
> 1. The first cell defines `syntaxtemplate`, a Vector with a `NamedTuple` for each token. This will be used to create an editable DataFrame.
> 2. The second cell builds a DataFrame, `syntaxsrcdf` from the preceding Vector of tuples. This is used to create a `PlutoGrid` editing widget above.
> 3. The third cell instantiates a DataFrame `syntax` from the widget's edited values.
> 4. The fourth cell composes a Mermaid diagram string for a syntax dataframe.
>

"""
else
	md""
end

# ╔═╡ 01ccc6f1-2271-41cb-bbfa-a95f727e912b
"""Construct named tuple with relations of passage `psg` in syntax dataframe `df`."""
function relationsforpassage(psg, df)
	psgmatches = filter(row -> row.passage == psg, df)
	if nrow(psgmatches) == 1 
		(n1 = psgmatches[1, :node1], n1relation = psgmatches[1,:node1rel],
		n2 = psgmatches[1, :node2], n2relation = psgmatches[1,:node2rel],
		)
	else
		nothing
	end
end;


# ╔═╡ 7bc296a5-d4ee-4a60-be7c-20df3a121176
"""Find index of a single node with token value `asyndeton`"""
function asyndetonidx(syndf)
	#filter(row -> row.sex == "male", df)
	asynmatches = filter(row -> row.token == "asyndeton", syndf)
	nrow(asynmatches) == 1 ? asynmatches[1,:reference] : nothing
end;
	

# ╔═╡ b9a97ce5-51cf-4db2-a407-021db51b24da
"""Compose Mermaid diagramd for syntax dataframe `syndf`."""
function mermadize(syndf)
	graphlines = [
		"graph BT;",
		"classDef implicit fill:#f96,stroke:#333;"
	]

	asynidx = asyndetonidx(syndf)
	global nodeidx = 0
	for r in eachrow(syndf)
		 nodeidx = nodeidx + 1
		if isnothing(r.node1rel)
			# skip
		else
			if r.token == "implied" 
				push!(graphlines, "class $(r.reference) implicit;")
			end
			push!(graphlines, string(r.reference, "[", r.token, "]", " --> |", r.node1rel, "| ", r.node1, "[", syndf[parse(Int, r.node1), :token], "];"))
			if ! isnothing(asynidx) && string(asynidx) == r.node1
				push!(graphlines, "class $(r.node1) implicit;")
			end
			if ! isnothing(r.node2)
				push!(graphlines, string(r.reference, "[", r.token, "]", " --> |", r.node2rel, "| ", r.node2, "[", syndf[parse(Int, r.node2), :token], "];"))
			end
			
		end
	end
	graphstr = join(graphlines, "\n")
end;

# ╔═╡ 5116aaa6-af7c-46e7-9e11-6059e587f5c0
if openhood
md"""> ### Documentation: file management NEEDS UPDATING
>
> 
>

"""
else
	md""
end

# ╔═╡ d86eca56-ea1f-4d32-bff2-44f26d12e3f4
begin
	mkpath(outputdir)
end;

# ╔═╡ 013963bc-d65f-449f-8bd5-ddda9dddb1fd
fname = replace(title, " " => "_");

# ╔═╡ b3565306-6e7b-4d02-901c-dec331b3da18
sentencesfile = joinpath(outputdir, fname * "_sentences.cex");

# ╔═╡ 887a6294-5987-4c94-98c6-d92634006bcc
vufile = joinpath(outputdir, fname * "_verbal_units.cex");

# ╔═╡ 26cc6db2-9164-4ceb-b87f-d812cb1e98ce
tokensfile = joinpath(outputdir, fname * "_tokens.cex");

# ╔═╡ fa278abd-db5d-4340-9795-94407ef9cbf7
function writevus(df, f; delimiter = "|")
	hdr = "vuid|semantic_type|syntactic_type|depth"
	lines = isfile(f) ? readlines(f) : [hdr]

	psg = sentencerange(sentence) |> passagecomponent
	rowidx = 0
	for row in eachrow(df)
		rowidx = rowidx + 1
		ref = string(psg,".", rowidx)
		push!(lines, join([ref, lowercase(row.semantic_type),lowercase(row.syntactic_type),row.depth], delimiter))
	end
	open(f, "a") do io
		write(f, join(lines,"\n"))
	end
	
	#md"Write contents of VU $(df) to $(f) $(sentid)"
	
end;

# ╔═╡ 03a20740-0756-4081-b2f6-335888238336
if openhood
md"""> ### Documentation: other UI functions NEEDS UPDATING
>
> The first two hidden cells include definitions of some CSS styles and colors to use in highlighting grouped text.  These are followed by cells with functions for  HTML formatting of content.
>
> Unhide them to see details.
>

"""
else
	md""
end

# ╔═╡ 0635610a-69b0-4a15-b086-236e3fd48a01
 css = html"""
<style>
 .connector {
 background: yellow;  
 font-style: bold;
}
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
</style>
 """

# ╔═╡ e7b6a508-81fb-4f40-bd34-185ce6a20e14
palette = ["#79A6A3;",
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
];

# ╔═╡ ab5048e0-e1c4-42ec-8837-a16dd231fe37
"""Format user instructions with Markdown admonition."""
instructions(title, text) = Markdown.MD(Markdown.Admonition("tip", title, [text]));

# ╔═╡ 3487cd67-8c0f-4fe0-8c3a-2d25bba023bd
begin
	overview = md"""
This notebook allows you to annotate the syntax of a citable Greek text, and save your annotations to simple delimited text files.

Begin by identifying a CEX source for a text to load. 	

The notebook will prompt you to make four kinds of annotations following the model [documented here](https://neelsmith.github.io/GreekSyntax/). There are four steps. 

1. Annotating the [connection of the sentence to its context](https://neelsmith.github.io/GreekSyntax/modelling/sentences/).
2. Identifying the sentence's [verbal units](https://neelsmith.github.io/GreekSyntax/modelling/verbal_units/).
3. Assigning individual tokens in the sentence to a verbal unit.
4. Annotating the syntactic relation of tokens (see [https://neelsmith.github.io/GreekSyntax/modelling/tokens/](https://neelsmith.github.io/GreekSyntax/modelling/tokens/) and [https://neelsmith.github.io/GreekSyntax/modelling/syntax/](https://neelsmith.github.io/GreekSyntax/modelling/syntax/)).


**Data source**
	
The current version of the notebook is configured to read a file derived from the tree bank data [here](https://perseids-publications.github.io/glaux-trees/xml/0540-001.xml). The Perseus treebank data is licensed under the [Creative Commons Attribution-Share Alike license version 4.0](https://github.com/perseids-publications/glaux-trees/blob/master/TREEBANK_LICENSE).
	
**Remaining TBD**

- validate all annotations	
- save to CEX
- improve format of input data
"""
	Foldable("How to use this notebook", instructions("Analyzing syntax", overview))
end


# ╔═╡ 910b86a4-b801-4a7a-bab7-9ad072e75bc3
begin
	loadmsg = md"""

Provide values for the three input boxes; for each input box, use the `Submit` button to save your entry.
	
1. Optionally, define a directory for saving results of your annotations. (By default,the notebook will create a subdirectory named `output` within the notebook's directory. If you enter a directory that does not exist, the notebook will attempt to create it.)	
1. Paste or type a URL into the second input box.
2. In the third input box enter a title to use in formatting text and saving your annotations in local files.

When you have configured all three input boxes, check `URL and title are correct`.

It may take a moment for the notebook to download and parse your file.	

"""
	Foldable("How to load texts to analyze", instructions("Loading files", loadmsg))
end


# ╔═╡ 336f2a45-45b1-4381-88af-e35a703574fb
if prereqsok()
	msg1 = md"""
1. Choose a sentence by number. (*Note that if you enter a non-numeric value, the notebook will show an error message.  The error messages will disappear when you enter an integer value.*)
2. Identify the conjunction or participle that connects it to the broader context, or choose `asyndeton` if there is none.
	"""


		Foldable("Step 1 instructions", instructions("Annotating a sentence", msg1))

end

# ╔═╡ d1496b85-c488-4130-a915-aeedfb1e45c0
"""Compose a menu to select the connecting word from the first N tokens of the current sentence.
"""
function connectormenu()
	menu = Pair{Union{Int64,Missing, Nothing}, String}[missing => "", nothing => "asyndeton"]
	for (i, tkn) in enumerate(sentence[1:ninitial])
		if tkn[2] != LexicalToken()
			# omit: punctuation
		else
			pr = (i => string(i, ". ", tkn[1].text))
			push!(menu, pr)
		end
	end
	menu
end;

# ╔═╡ c405681f-4271-46d5-a49f-f8da7bdfe3ed
if prereqsok()
	if sentid == 0
	md""	
	else
		md"*Connecting word*: $(@bind connectorid Select(connectormenu()))"
	end
end

# ╔═╡ 97f0be7b-aafc-4180-a2f3-aa43d2c65358
"""True if requirements for sentence-level annotation (step 1) are satisfied"""
function step1()
	if @isdefined(connectorid) && isnothing(connectorid)
		# asyndeton
		true
		
	elseif @isdefined(connectorid) == false || sentid == 0 || ismissing(connectorid) || isnothing(connectorid)
		false
		
	else
		true
	end
end;

# ╔═╡ a638caf3-94c9-4a03-8fa4-05d99d8e135a
if step1()
	md"""### Step 2. Define verbal units"""
else
	md""
end

# ╔═╡ b8ab34a6-2336-471c-bb74-6ad0800ba22d
if step1()
	msg2 = md"""
1. Use the button labelled `Initialize list of verbal units`  to create a new list.
2. Enter a row for each verbal unit with values for its syntactic and semantic type, and for its level of subordination.  (See [this page](https://neelsmith.github.io/GreekSyntax/modelling/verbal_units/) for details.)
3. When you	are done, check the `Done` box.
	"""

	Foldable("Step 2 instructions", instructions("Defining verbal units", msg2))
else
	md""
end

# ╔═╡ f465f45f-79ac-4ad3-951d-c7161ddebb6f
if step1()
	md"""*Done* $(@bind vusdefined CheckBox()) $(@bind initialize Button("Initialize list of verbal units"))"""
else
	md""
end


# ╔═╡ 3181e436-9270-48ed-8d15-da8ad9e4927e
let initialize  
	if step1()
	@bind vus editable_table(vusrcdf; filterable=true, pagination=true, height = 300)
	else
		md""
	end
end

# ╔═╡ f21fd0c4-602c-4782-908c-3dcd91ad936d
"""True if Step 2 editing is complete."""
function step2()
	@isdefined(vusdefined) && vusdefined && step1()
end;

# ╔═╡ 43f8b9d1-b59b-49f2-9441-f582f08a7a11
if step2()
	md"""### Step 3. Assign tokens to verbal units
	"""
else
	md""
end

# ╔═╡ 5bc46f28-1c9a-4cb8-ab24-7fe47a276554
if step2()
	msg3 = md"""Assign each token to one of the verbal units you have defined above.  Fill in the sequential number of the verbal unit. (You can unfold the `Show verbal units` list if you don't want to scroll back up the notebook.)

	Any connecting words you identified in Step 1 should be left as verbal unit 0.

	When you have associated each token with the correct verbal unit, check `Done`.
	"""
	Foldable("Step 3 instructions", instructions("Assigning tokens to verbal units", msg3))
else
	md""
end

# ╔═╡ b8240f2d-de6b-457e-b629-af55def6c53f
if step2()
	md"""Indented by level of subordination:"""
end

# ╔═╡ 4ca90ce5-c1e2-4f35-9e02-81788522c90e
if step2()
	md"""*Done* $(@bind tokensassigned CheckBox())"""
else
	md""
end

# ╔═╡ fedf66bc-7e15-4a4b-8dab-5aec0f07944e
vudf = step2() ? create_dataframe(vus) : nothing;

# ╔═╡ 55b94fc8-0133-492b-baf1-2f8ed580e701
if step2()
	if nrow(vudf)== 1
		md"""**Step 2** result: **1 verbal unit** defined."""
	elseif nrow(vudf) > 1
		md"""**Step 2** result: **$(nrow(vudf)) verbal units** defined."""
	else
		md""
	end
end

# ╔═╡ 7a768206-49a6-44b2-99e3-4448af4fb543
if step2()
	if nrow(vudf) == 0
	md""
else
	vulistmd = []
	for r in eachrow(vudf)
		push!(vulistmd, string("1. ", r.syntactic_type, " (level ", r.depth, ")"))
	end
	vuliststr = join(vulistmd, "\n")
	Foldable("Show verbal units",Markdown.parse(vuliststr))
end
else
md""
end

# ╔═╡ 68d9874a-d106-4fbc-8935-82e80cc92f9f
"""True if Step 3 editing is complete."""
function step3()
	step2() && tokensassigned
end;

# ╔═╡ 5d167ed1-905c-44bd-8b7d-e174f4a0eb04
if step3()
	md"""### Step 4. Define syntactic relations"""
else
	md""
end

# ╔═╡ ec6d4eb1-32dc-4dc5-82ab-eafba0540da8
if step3()
	msg4 = md"""Associate each token with a token it depends on, and define their relation.  If the token is a conjunction or a relative clause, you should also 
	associate it with a second token and define that relation, too. See the (*forthcoming*) guide.

	When you are through, Check the box labeled  `Save to files...` to append all your annotations for this sentence to delimited-text files (one each for sentence, verbal unit, and token annotations).
	"""
	Foldable("Step 4 instructions",
	instructions("Assigning tokens to verbal units", msg4))
else
	md""
end

# ╔═╡ db3c92ef-9cab-4adf-b128-3f3e7eda885d
if step3()
	
	md"""#### Save final results
*Save to files named* $(fname)_`[TYPE]`.cex $(@bind saveall CheckBox())
"""
end

# ╔═╡ fafa2505-fe2c-4a46-9e43-a54f44e9522f
if step3()
	if nrow(vudf) == 0
	md""
else
	syntaxtips = [
	"- **TBA**.  Full documentation and user guide will be posted [here](https://neelsmith.github.io/GreekSyntax/modelling/syntax/)"
	]
	syntaxtipstr = join(syntaxtips, "\n")
	Foldable("See cheat sheet for syntactic relations",Markdown.parse(syntaxtipstr))
end
	else
		md""
	end

# ╔═╡ 1d76a211-4942-4113-a4ea-13fa9e098168
tokenlist = if step1()
	local tokentuples = []
	for (tkn, tkntype) in sentence
		if typeof(tkntype) == LexicalToken
			push!(tokentuples, (passage = string(passagecomponent(tkn.urn)), token = tkn.text, group = 0))
		end
	end
	tokentuples
else
	[]
end;

# ╔═╡ 140f25e2-e6b0-47df-a377-c92b3a82c94c
tokengroupsdf = DataFrame(tokenlist);

# ╔═╡ 3ae3b338-2e05-4a31-aca3-ebc6b71f3d4c
if step2()
	@bind tokengroups editable_table(tokengroupsdf; filterable=true, pagination=true)
else 
	md""
end

# ╔═╡ 14c7b897-8ae7-4f01-94a7-9dfca51ba04f
assignedtokensdf = @isdefined(tokengroups) ? create_dataframe(tokengroups) : nothing;

# ╔═╡ 031d14de-ce21-4d2c-9b1c-9ddbaf59bb01
# Add display with level indentation
if step2()
	indentedtext = []
	local currindent = 0
	currstring = [""]
	for r in eachrow(assignedtokensdf)
		if r.group == 0
			
		else
			matchingdepth = vudf[r.group,:depth]
			if currindent == matchingdepth
				push!(indentedtext, " $(r.token)")
				
			else
				if (currindent != 0)
					push!(indentedtext, repeat("</blockquote>", currindent))
				end
					push!(indentedtext,  repeat("<blockquote>", matchingdepth) * "<strong>$(matchingdepth)</strong>. " * repeat(">", matchingdepth) * " "  )
				
				currindent = matchingdepth
				push!(indentedtext, " $(r.token)")
			end
		end
		
	end
	join(indentedtext) |> HTML
else
	md""
end

# ╔═╡ 1f9b98d9-a7e0-43bf-a651-5e2e3afc85cf
syntaxtemplate = if loadedok()
	local implicitcount = 0

	local seq = 0
	nopunct = filter(sentence) do (tkn, ttype)
		ttype isa LexicalToken
	end
	syntaxstrings = map(nopunct) do (tkn,ttype)
		seq = seq + 1
		passage = string(passagecomponent(tkn.urn))
		(passage = passage, reference = seq, token = tkn.text, node1 = missing, node1rel = missing, node2 = missing, node2rel = missing)
	end
	if isnothing(connectorid)
		psg = sentencerange(sentence) |> passagecomponent
		deranged = replace(psg, "-" => "_")
		extrarow = (passage = string( "_asyndeton_",deranged), reference = seq + 1, token = "asyndeton", node1 = missing, node1rel = missing, node2 = missing, node2rel = missing)
		push!(syntaxstrings, extrarow)
	end
	syntaxstrings
end;

# ╔═╡ a72eeaa5-a54a-4475-868a-1e21eee19b71
syntaxsrcdf = if loadedok()
	DataFrame(syntaxtemplate);
end;

# ╔═╡ 69451dde-a999-4c1f-a8e4-ed731e282149
if step3()
	@bind syntaxdf editable_table(syntaxsrcdf; filterable=true, pagination=true)
else
	md""
end

# ╔═╡ ca48466c-cd85-456e-ac50-072490cdbc8b
syntax = @isdefined(syntaxdf) ? create_dataframe(syntaxdf) : nothing;

# ╔═╡ fe16ab5c-9065-4518-8ac3-38e3506d7633
if step3()
	graphstr = mermadize(syntax)
	mermaid"""$(graphstr)"""

	
else 
	md""
end

# ╔═╡ d1edf3dd-503d-4b08-b153-a050d8a44a46
function writetokens(sent, syntaxdf,groupsdf, f; delimiter = "|")
	hdr = "urn|tokentype|text|verbalunit|node1|node1relation|node2|node2relation"
	lines = isfile(f) ? readlines(f) : [hdr]

	psg = sentencerange(sentence) |> passagecomponent			
	rowidx = 0

	for (tkn, ttype) in sent
		tkngroup = groupforpassage(passagecomponent(tkn.urn), groupsdf)
		tknrelations = relationsforpassage(passagecomponent(tkn.urn),syntax)
		datarow = if isnothing(tknrelations)
			[tkn.urn, typelabel(ttype), tkn.text, tkngroup,
				nothing, nothing, nothing, nothing
		
		]
		else
			[tkn.urn, typelabel(ttype), tkn.text, tkngroup,
				tknrelations.n1, tknrelations.n1relation, 
				tknrelations.n2, tknrelations.n2relation
		]
		end
		 
		push!(lines, join(datarow, delimiter))
	end
	
	open(f, "w") do io
		write(f, join(lines,"\n"))
	end
end;

# ╔═╡ 88ea3ada-dc10-44b5-8d2f-70ef78b7a3fe
"""Append record for current sentence to delimited text file."""
function writesentence(f; delimiter = "|")
	senturn = sentencerange(sentence)
	hdr = "sentence$(delimiter)connector"
	lines = isfile(f) ? readlines(f) : [hdr]
	if isnothing(connectorid) 
		push!(lines, string(senturn, delimiter, nothing) )
	else
		connectorurn = sentence[connectorid][1].urn
		push!(lines, string(senturn, delimiter, connectorurn))
	end
	open(f, "a") do io
		write(f, join(lines,"\n"))
	end
	#checkrecc = readlines(f)
	
end;

# ╔═╡ c205e757-4e5a-4b22-ac53-bdad947a942c
if step3()
	if saveall
		
		
		
		writesentence(sentencesfile)
		writevus(vudf, vufile)

		writetokens(sentence, syntax, assignedtokensdf, tokensfile)
		sentrecords = readlines(sentencesfile) |> length
		vurecords = readlines(vufile)|> length
		tknrecords = readlines(tokensfile) |> length
		
		
		md"""**Results of saving files**:  wrote
		
- records for sentences: $(sentrecords - 1)
- records for verbal units: $(vurecords - 1)
- records for tokens: $(tknrecords - 1)
"""
	end
end

# ╔═╡ 47b1c7b5-3306-45c0-bf14-54c978506b68
"""Format string value of tokens in `s` with appropriate
white space for lexical and punctuation tokens.  Add HTML
`span` tags for manually tagged stuff.
"""
function formatsentenceBW(s)
	formatted = []

	counter = 0
	for (tkn, tkntype) in s
		counter = counter + 1
		if typeof(tkntype) == LexicalToken
			if ismissing(connectorid) || isnothing(connectorid) || ! (counter == connectorid)
				push!(formatted, " " * tkn.text)
			else
				tagged = "<span class=\"connector\")>$(tkn.text)</span>"
				push!(formatted, " " * tagged)
			end
			
		else
			push!(formatted, tkn.text)
		end
	end
	
	join(formatted,"")
end;

# ╔═╡ 0f48fb75-ab9d-4ab6-b619-f605e59dd00e
"""Compose HTML representation of current sentence with 
color coding of verbal units."""
function formatColored(s, groupsdf)
	groupedtext = []
	global groupidx = 0

	if isnothing(groupsdf)
		""
	else
		for r in eachrow(groupsdf)
			groupidx = groupidx + 1
				
			if groupidx == connectorid
				push!(groupedtext, " <span class=\"connector\">$(r.token)</span>")
					
			elseif r.group == 0
					push!(groupedtext, " <span class=\"unassigned\">$(r.token)</span>")
			else
				coloridx = mod(r.group, length(palette)) + 1
				push!(groupedtext, " <span class=\"tooltip\" style=\"color: $(palette[coloridx])\">$(r.token)</span>")
					


			end
				
		end
	end

	join(groupedtext,"") 
end;

# ╔═╡ 8aab14ce-c3f6-428c-8985-11ca2ce1ed1f
"""Format string value of tokens in `s` with approrpiate
white space for lexical and punctuation tokens.  Add HTML
`span` tags for manually tagged stuff.
"""
function formatsentence(s)
	if isnothing(assignedtokensdf)
		formatsentenceBW(s)
	else
		formatColored(s, assignedtokensdf)
	end
		
end;

# ╔═╡ b41983f5-8774-4e4b-98fa-58087551971f
if prereqsok()
	if sentid == 0
		md""

	else
		local currpsg = sentencerange(sentence) |> passagecomponent
		if ismissing(connectorid)
			str = formatsentence(sentence)
			
			HTML("<i>Please identify a connecting word for this sentence, or select <q>asyndeton</q>:</i><br/><blockquote><strong>$(currpsg)</strong>: " * str * "</blockquote>")
	
		elseif isnothing(connectorid)
				str = formatsentenceBW(sentences[sentid])
				
				HTML("<p><b>Step 1 result:</b></p><blockquote><span class=\"connector\">Asyndeton: no connecting word.</span><br/><strong>$(currpsg)</strong>: " * str * "</blockquote>")
			
		else
			str = formatsentenceBW(sentences[sentid])
			HTML("<p><b>Step 1 result:</b></p><blockquote><strong>$(currpsg)</strong>: " * str * "</blockquote>")
		end
	end
end

# ╔═╡ 0e0cd61d-f4d0-4615-a413-4dae483b031b
if step1()
	local currpsg = sentencerange(sentence) |> passagecomponent
	HTML("<i>Define verbal units for:</i><br/><br/><blockquote><strong>$(currpsg)</strong>: " * str * "</blockquote>")

end

# ╔═╡ 990de15b-b64f-4830-9740-3d97b93594c4
if step2() == false || nrow(assignedtokensdf) == 0
		md""
else
	HTML("""<p>Colored by group:<br/><br/><blockquote>
$(formatsentence(sentence))</blockquote></p>
	""")
	
end

# ╔═╡ 7d418f4f-ffb5-4048-8dd2-8535c6d5f664
if step3()
		HTML("""<p><b>Step 3 results</b><br/><blockquote>
$(formatsentence(sentence))</blockquote></p>
	""")
end

# ╔═╡ a4a599ce-6362-4b57-a359-0ee1e8d12006
if step3() 
	HTML("""<h4>Edit syntactic relations</h4><br/><blockquote>
$(formatsentence(sentence))</blockquote></p>
	""")
end

# ╔═╡ 2bffa4ea-03c2-4cda-8b7d-b166e0b9939b
if openhood
md"""> ### Documentation: morphology formatting that properly belongs in the (still unpublished) `Treebanks` package
>
> The following hidden cell defines a `morphlabel`  function to convert codes in AGLDT tree banks to human-readable labels.
"""
end

# ╔═╡ 65b236c8-fbb2-4002-a072-4dfc64723f13
"""Convert treebank project's code to readable label for morphology.
"""
function morphlabel(s)
	"Readable label for $(s)"
end;

# ╔═╡ Cell order:
# ╟─d345d44b-a9ed-4d70-a470-1f1cb53a18a9
# ╟─31cc3ad6-ac34-49f7-a86f-575a08eb1358
# ╟─2009a8a2-7f18-11ed-32f5-2d0ae7ffdde8
# ╟─9c197585-a2dd-42d2-b45c-deb5f756434b
# ╟─ed67e569-147c-4899-b338-f3282d9474b1
# ╟─d227b2f4-5cdd-4ef6-ae7c-0a8f02f1f966
# ╟─44a1635c-41af-450e-b06e-670367ae489b
# ╟─3487cd67-8c0f-4fe0-8c3a-2d25bba023bd
# ╟─d865bcd7-ef34-48d1-9526-623578822e42
# ╟─910b86a4-b801-4a7a-bab7-9ad072e75bc3
# ╟─3c3003e6-ebe9-434a-8960-6504b0e1578e
# ╟─58b8e896-1d55-4d43-8d93-d9421f1d85bf
# ╟─b092c825-d4f8-4f3d-a8b1-57a6a642290d
# ╟─ccb5e655-9bb1-4117-9231-f9a90855b48b
# ╟─73cb1d9d-c265-46c5-ae8d-1d940379b0d1
# ╟─7ff0baa8-3354-4300-81bc-90466b049e73
# ╟─b6cb23ee-8870-41b5-a800-d91d88dc2c28
# ╟─c21618ab-7092-4696-9508-8f8efc052917
# ╟─0ce311b0-fcad-4e98-9b1f-42005f44e509
# ╟─336f2a45-45b1-4381-88af-e35a703574fb
# ╟─4627ab0d-42a8-4d92-9b0d-c933b1b41f50
# ╟─a050416e-9b64-4103-8859-170d3912339d
# ╟─c405681f-4271-46d5-a49f-f8da7bdfe3ed
# ╟─b41983f5-8774-4e4b-98fa-58087551971f
# ╟─a638caf3-94c9-4a03-8fa4-05d99d8e135a
# ╟─b8ab34a6-2336-471c-bb74-6ad0800ba22d
# ╟─0e0cd61d-f4d0-4615-a413-4dae483b031b
# ╟─f465f45f-79ac-4ad3-951d-c7161ddebb6f
# ╟─3181e436-9270-48ed-8d15-da8ad9e4927e
# ╟─55b94fc8-0133-492b-baf1-2f8ed580e701
# ╟─43f8b9d1-b59b-49f2-9441-f582f08a7a11
# ╟─5bc46f28-1c9a-4cb8-ab24-7fe47a276554
# ╟─b8240f2d-de6b-457e-b629-af55def6c53f
# ╟─031d14de-ce21-4d2c-9b1c-9ddbaf59bb01
# ╟─990de15b-b64f-4830-9740-3d97b93594c4
# ╟─7a768206-49a6-44b2-99e3-4448af4fb543
# ╟─4ca90ce5-c1e2-4f35-9e02-81788522c90e
# ╟─3ae3b338-2e05-4a31-aca3-ebc6b71f3d4c
# ╟─7d418f4f-ffb5-4048-8dd2-8535c6d5f664
# ╟─5d167ed1-905c-44bd-8b7d-e174f4a0eb04
# ╟─ec6d4eb1-32dc-4dc5-82ab-eafba0540da8
# ╟─db3c92ef-9cab-4adf-b128-3f3e7eda885d
# ╟─c205e757-4e5a-4b22-ac53-bdad947a942c
# ╟─a4a599ce-6362-4b57-a359-0ee1e8d12006
# ╟─fe16ab5c-9065-4518-8ac3-38e3506d7633
# ╟─fafa2505-fe2c-4a46-9e43-a54f44e9522f
# ╟─69451dde-a999-4c1f-a8e4-ed731e282149
# ╟─7183fd4d-f180-474f-81d5-524aaf7f0152
# ╟─736baf25-214a-4d22-9003-a4d33155b36e
# ╟─ae140e63-0e4d-4978-b6c2-9f135cac8163
# ╟─2b3381a1-a82a-441a-81a4-7aa0e62ceac6
# ╟─47c1d979-f814-404d-80b1-adf3fcd1d337
# ╟─0f38d603-8b1d-451f-8be7-2162e055073f
# ╟─9ad3cf28-d403-449e-a8db-cc8a5fe84bee
# ╟─41a654d1-44d7-476b-b421-8f83d254f14e
# ╟─3294b863-69ce-46d4-9465-7db4f2a52996
# ╟─80010946-099e-4e1f-893b-f32aef12783e
# ╟─a8e032a5-94f8-4937-aad1-016883116f85
# ╟─b5be20e7-4eec-405b-9aa6-dfbd6aedbecd
# ╟─3a49b461-e4c2-44cb-9600-9ec10bf1e91f
# ╟─15deb4e6-4d84-4862-b453-d33cb96a02c7
# ╟─97f0be7b-aafc-4180-a2f3-aa43d2c65358
# ╟─d193df28-4805-49f7-a5ea-c2885be9cd98
# ╟─86264609-3fb6-479b-9289-35bb31e7999b
# ╟─187adacf-badf-482c-976a-9348e60b4c04
# ╟─6c7b400c-0a73-42f7-93b5-ceb8e7c5960c
# ╟─fedf66bc-7e15-4a4b-8dab-5aec0f07944e
# ╟─f21fd0c4-602c-4782-908c-3dcd91ad936d
# ╟─86b59bc9-0cbb-4913-a67e-23f19fcd73a4
# ╟─1d76a211-4942-4113-a4ea-13fa9e098168
# ╟─140f25e2-e6b0-47df-a377-c92b3a82c94c
# ╟─7b206be8-19cc-49b4-98a9-b39177701f2b
# ╟─14c7b897-8ae7-4f01-94a7-9dfca51ba04f
# ╟─68d9874a-d106-4fbc-8935-82e80cc92f9f
# ╟─419c6fe4-b41f-4045-a2d2-c14a9b255f35
# ╟─01ccc6f1-2271-41cb-bbfa-a95f727e912b
# ╟─1f9b98d9-a7e0-43bf-a651-5e2e3afc85cf
# ╟─a72eeaa5-a54a-4475-868a-1e21eee19b71
# ╟─ca48466c-cd85-456e-ac50-072490cdbc8b
# ╟─7bc296a5-d4ee-4a60-be7c-20df3a121176
# ╟─b9a97ce5-51cf-4db2-a407-021db51b24da
# ╟─5116aaa6-af7c-46e7-9e11-6059e587f5c0
# ╟─d86eca56-ea1f-4d32-bff2-44f26d12e3f4
# ╟─013963bc-d65f-449f-8bd5-ddda9dddb1fd
# ╟─b3565306-6e7b-4d02-901c-dec331b3da18
# ╟─887a6294-5987-4c94-98c6-d92634006bcc
# ╟─26cc6db2-9164-4ceb-b87f-d812cb1e98ce
# ╟─d1edf3dd-503d-4b08-b153-a050d8a44a46
# ╟─fa278abd-db5d-4340-9795-94407ef9cbf7
# ╟─88ea3ada-dc10-44b5-8d2f-70ef78b7a3fe
# ╟─03a20740-0756-4081-b2f6-335888238336
# ╟─0635610a-69b0-4a15-b086-236e3fd48a01
# ╟─e7b6a508-81fb-4f40-bd34-185ce6a20e14
# ╟─ab5048e0-e1c4-42ec-8837-a16dd231fe37
# ╟─8aab14ce-c3f6-428c-8985-11ca2ce1ed1f
# ╟─47b1c7b5-3306-45c0-bf14-54c978506b68
# ╟─0f48fb75-ab9d-4ab6-b619-f605e59dd00e
# ╟─d1496b85-c488-4130-a915-aeedfb1e45c0
# ╟─2bffa4ea-03c2-4cda-8b7d-b166e0b9939b
# ╟─65b236c8-fbb2-4002-a072-4dfc64723f13
