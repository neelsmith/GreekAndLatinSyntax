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
	Pkg.instantiate()

	Pkg.add("PlutoUI")
	using PlutoUI
	Pkg.add("Downloads")
	using Downloads
	Pkg.add("Kroki")
	using Kroki
	Pkg.add("CitableText")
	using CitableText
	Pkg.add("PlutoTeachingTools")
	using PlutoTeachingTools

	Pkg.add("DataFrames")
	using DataFrames

	Pkg.add(url = "https://github.com/lungben/PlutoGrid.jl")
	using PlutoGrid

	
	md"""(*Unhide this cell to see environment setup.*)"""
end

# ╔═╡ a1a1e499-0a67-413b-97a2-6be49eab09bc
md"""*Notebook version:* **0.0.1**  *See version history* $(@bind history CheckBox())
"""

# ╔═╡ d227b2f4-5cdd-4ef6-ae7c-0a8f02f1f966
if history
md"""

- **0.0.1**: initial version supports fully analyzing syntax.  Does *not* yet validate user annotations,  cite text by CTS URN, or save results to external file.
"""
else
		md""
	
	
end

# ╔═╡ 44a1635c-41af-450e-b06e-670367ae489b
md""" ## Analyze Greek syntax
"""

# ╔═╡ b092c825-d4f8-4f3d-a8b1-57a6a642290d
md"""*This is the source for the text we will annotate*:

	"""

# ╔═╡ 8f346da9-00cc-4b3f-8b55-b006bea8bb60
treebankurl = "https://raw.githubusercontent.com/neelsmith/Treebanks.jl/main/lys1tb.cex"

# ╔═╡ 0ce311b0-fcad-4e98-9b1f-42005f44e509
md"""### Step 1. Annotate the connection of the sentence to its context."""

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
	md"""> ### Prerequisites: loading and formatting data
>
>The following two hidden cells download data from the URL defined at the top of this notebook, and format it as Vectors of Tuples, one for each sentence. The resulting (global) Vector is named `sentences`.
>
> Unhide them to see details.	
"""
else
	md""
end

# ╔═╡ a8e032a5-94f8-4937-aad1-016883116f85
"""Load per-token data from `url`, and format as Vectors of Tuples
organized by sentence.
"""
function loaddata(url)
	rawlines = map(ln -> split(ln, "|"), Downloads.download(url) |> readlines)
	datalines = map(rawlines[2:end]) do cols
		(parse(Int,passagecomponent(collapsePassageBy(CtsUrn(cols[1]), 1))), cols[3], cols[5])
	end
	sentencetokens = []
	currentsentence = []
	sentid = 0
	for trip in datalines
		if trip[1] == sentid
			push!(currentsentence, trip)
		else
			push!(sentencetokens, currentsentence)
			sentid = sentid + 1
			currentsentence = [trip]
		end
	end
	filter(s -> !isempty(s), sentencetokens)
end;

# ╔═╡ 9ad3cf28-d403-449e-a8db-cc8a5fe84bee
# Data triples for each token, grouped by sentence
sentences = loaddata(treebankurl);

# ╔═╡ 7ff0baa8-3354-4300-81bc-90466b049e73
md"Loaded **$(length(sentences))** sentences. "

# ╔═╡ 4627ab0d-42a8-4d92-9b0d-c933b1b41f50
md"""

*Choose a sentence to analyze*: $(@bind sentid NumberField(0:length(sentences)))"""

# ╔═╡ b5be20e7-4eec-405b-9aa6-dfbd6aedbecd
if openhood
	md"""> ### Step 1: annotating a sentence
> Summary of the following three hidden cells:
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
sentence = sentid == 0 ? [] : sentences[sentid];

# ╔═╡ a050416e-9b64-4103-8859-170d3912339d
if sentid == 0
		md""
else 
	md"""*Choose a connecting word from this many initial tokens:* $(@bind ninitial Slider(1:length(sentence), show_value = true, default = 10) )
"""

end
	

# ╔═╡ d1496b85-c488-4130-a915-aeedfb1e45c0
"""Compose a menu to select the connecting word from the first N tokens of the current sentence.
"""
function connectormenu()
	menu = Pair{Union{Int64,Missing, Nothing}, String}[missing => "", nothing => "asyndeton"]
	for (i, tkn) in enumerate(sentence[1:ninitial])
		if tkn[3] == "u--------"
			# omit: punctuation
		else
			pr = (i => string(i, ". ", tkn[2]))
			push!(menu, pr)
		end
	end
	menu
end;

# ╔═╡ c405681f-4271-46d5-a49f-f8da7bdfe3ed
if sentid == 0
	md""	
else
	md"*Connecting word*: $(@bind connectorid Select(connectormenu()))"
end

# ╔═╡ 97f0be7b-aafc-4180-a2f3-aa43d2c65358
"""True if requirements for sentence-level annotation (step 1) are satisfied"""
function step1()
	if @isdefined(connectorid) == false || sentid == 0 || ismissing(connectorid) || isnothing(connectorid)
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

# ╔═╡ f465f45f-79ac-4ad3-951d-c7161ddebb6f
if step1()
	md"""*Done* $(@bind vusdefined CheckBox()) $(@bind initialize Button("Initialize list of verbal units"))"""
else
	md""
end


# ╔═╡ d193df28-4805-49f7-a5ea-c2885be9cd98
if openhood
md"""> ### Step 2. Define verbal units
>
> The next trhee hidden cells manage creating and editing a DataFrame defining the verbal units in the current sentene.
>
> 1. The first cell defines a function that returns a DataFrame with a single row for an independent clause. This is used to initialize the editing widget in the UI above using [PlutoGrid](https://github.com/lungben/PlutoGrid.jl).
> 2. The second clause instantiates a DataFrame `vudf` from the edited values in the editing widget. This is how other cells can access edited values, since the source DataFrame is unmodified by the editing widget.
> 3. Defines a function `step2` that is true if step 2 editing is complete.
>
> Unhide them to see details.

"""
else
	md""
end

# ╔═╡ 187adacf-badf-482c-976a-9348e60b4c04
"""Define a DataFrame for recording verbal units"""
function newvudf()
	DataFrame(syntactic_type = ["Independent clause"], semantic_type = "ADD VALUE HERE", depth = 1)
end;

# ╔═╡ 3181e436-9270-48ed-8d15-da8ad9e4927e
let initialize
	if step1()
	@bind vus editable_table(newvudf(); filterable=true, pagination=true, height = 300)
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
md"""**Step 2** result: **$(nrow(vudf)) verbal units** defined.

"""
else
	md""
end

# ╔═╡ 7a768206-49a6-44b2-99e3-4448af4fb543
if step2()
	if nrow(vudf) == 0
	md""
else
	vulistmd = []
	for r in eachrow(vudf)
		push!(vulistmd, string("1. ", r.syntactic_type, "(level ", r.depth, ")"))
	end
	vuliststr = join(vulistmd, "\n")
	Foldable("Show verbal units",Markdown.parse(vuliststr))
end
else
md""
end

# ╔═╡ 86b59bc9-0cbb-4913-a67e-23f19fcd73a4
if openhood
md"""> ### Step 3. Assign tokens to verbal units
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

# ╔═╡ 1d76a211-4942-4113-a4ea-13fa9e098168
tokenlist = begin
	tknstrings = map(sentence) do trip
		(token = string(trip[2]), group = 0)
	end	
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

# ╔═╡ 68d9874a-d106-4fbc-8935-82e80cc92f9f
"""True if Step 3 editing is complete."""
function step3()
	step2() && tokensassigned
end;

# ╔═╡ 85b50b49-584d-4be8-ba33-2d7c72473eb3
if step3()
	md"**Step 3 results:**"
else
	md""
end

# ╔═╡ 5d167ed1-905c-44bd-8b7d-e174f4a0eb04
if step3()
	md"""### Step 4. Define syntactic relations"""
else
	md""
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

# ╔═╡ 419c6fe4-b41f-4045-a2d2-c14a9b255f35
if openhood
md"""> ### Step 4. Annotate syntax
>
> The following hidden cells manage the dataframe for annotating syntax.
>
> 1. The first cell defines `syntaxtemplate`, a Vector with a `NamedTuple` for each token. This will be used to create an editable DataFrame.
> 2. The second cell builds a DataFrame, `syntaxsrcdf` from the preceding Vector of tuples. This is used to create a `PlutoGrid` editing widget above.
> 3. The third cell instantiates a DataFrame `syntax` from the widget's edited values.
>

"""
else
	md""
end

# ╔═╡ 1f9b98d9-a7e0-43bf-a651-5e2e3afc85cf
syntaxtemplate = begin
	syntaxidx = 0
	syntaxstrings = map(sentence) do trip
		global syntaxidx = syntaxidx + 1
		(reference = syntaxidx, token = string(trip[2]), node1 = missing, node1rel = missing, node2 = missing, node2rel = missing)
	end
	
end;

# ╔═╡ a72eeaa5-a54a-4475-868a-1e21eee19b71
syntaxsrcdf = DataFrame(syntaxtemplate);

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
	graphlines = [
		"graph BT;"
	]

	nodeidx = 0
	for r in eachrow(syntax)
		global nodeidx = nodeidx + 1
		if isnothing(r.node1rel)
			# skip
		
		else
			push!(graphlines, string(r.reference, "[", r.token, "]", " --> |", r.node1rel, "| ", r.node1, "[", syntax[parse(Int, r.node1), :token], "];"))
		end
	end
	graphstr = join(graphlines, "\n")
	mermaid"""$(graphstr)"""
else 
	md""
end

# ╔═╡ 03a20740-0756-4081-b2f6-335888238336
if openhood
md"""> ### Other UI functions
>
> The first two hidden cells include definitions of some CSS styles and colors to use in highlighting grouped text.  These are followed by cells with functions for HTML formatting of content.
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
 
</style>
 """

# ╔═╡ e7b6a508-81fb-4f40-bd34-185ce6a20e14
palette = ["#79A6A3;",
	"#E5B36A;",
	"#C7D7CA;",
	"#E7926C;"
];

# ╔═╡ ab5048e0-e1c4-42ec-8837-a16dd231fe37
"""Format user instructions with Markdown admonition."""
instructions(title, text) = Markdown.MD(Markdown.Admonition("tip", title, [text]));

# ╔═╡ 3487cd67-8c0f-4fe0-8c3a-2d25bba023bd
begin
	overview = md"""
This notebook allows you to annotate the syntax of Greek text.

The notebook reads in a "treebank" file and prompts you to make four kinds of annotations following the model [documented here](https://neelsmith.github.io/GreekSyntax/). There are four steps. 

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


# ╔═╡ 336f2a45-45b1-4381-88af-e35a703574fb
begin
	msg1 = md"""
1. Choose a sentence by number. (*Note that if you enter a non-numeric value, the notebook will show an error message.  The error messages will disappear when you enter an integer value.*)
2. Identify the conjunction or participle that connects it to the broader context, or choose `asyndeton` if there is none.
	"""


		Foldable("Step 1 instructions", instructions("Annotating a sentence", msg1))

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

# ╔═╡ ec6d4eb1-32dc-4dc5-82ab-eafba0540da8
if step3()
	msg4 = md"""Associate each token with a token it depends on, and define their relation.  If the token is a conjunction or a relative clause, you should also 
	associate it with a second token and define that relation, too.
	"""
	Foldable("Step 4 instructions",
	instructions("Assigning tokens to verbal units", msg4))
else
	md""
end

# ╔═╡ 47b1c7b5-3306-45c0-bf14-54c978506b68
"""Format string value of tokens in `s` with approrpiate
white space for lexical and punctuation tokens.  Add HTML
`span` tags for manually tagged stuff.
"""
function formatsentence(s)
	formatted = []
	for (i, tkn) in enumerate(s)
		if tkn[3] == "u--------" # punctuation
			push!(formatted, tkn[2])
		elseif ismissing(connectorid) || isnothing(connectorid) || ! (i == connectorid)
			push!(formatted, " " * tkn[2])
		else # i == connectorid
			tagged = "<span class=\"connector\">$(tkn[2])</span>"
			push!(formatted, " " * tagged)
			
		end
	end
	join(formatted,"")
end;

# ╔═╡ b41983f5-8774-4e4b-98fa-58087551971f
if sentid == 0
	md""
	
elseif ismissing(connectorid)
		str = formatsentence(sentences[sentid])
		HTML("<i>Please identify a connecting word for this sentence, or select <q>asyndeton</q>:</i><br/><blockquote><strong>Sentence $(sentid)</strong>: " * str * "</blockquote>")

elseif isnothing(connectorid)
		str = formatsentence(sentences[sentid])
		HTML("<p><b>Step 1 result:</b></p><blockquote><span class=\"connector\">Asyndeton: no connecting word.</span><br/><strong>Sentence $(sentid)</strong>: " * str * "</blockquote>")
	
else
	
	str = formatsentence(sentences[sentid])
	HTML("<p><b>Step 1 result:</b></p><blockquote><strong>Sentence $(sentid)</strong>: " * str * "</blockquote>")
end


# ╔═╡ 22415bd0-f22b-4cc8-8b7a-dfaf03c7c228
"""Build an HTML `blockquote` displaying the current sentence with highlighting.
"""
function displaysentence()
	if sentid == 0
	md""
	
	elseif isnothing(connectorid)
			str = formatsentence(sentences[sentid])
			HTML("<blockquote><span class=\"connector\">Asyndeton: no connecting word.</span><br/><strong>Sentence $(sentid)</strong>: " * str * "</blockquote>")
		
	else
		
		str = formatsentence(sentences[sentid])
		HTML("<blockquote><strong>Sentence $(sentid)</strong>: " * str * "</blockquote>")
	end
end;

# ╔═╡ 0e0cd61d-f4d0-4615-a413-4dae483b031b
displaysentence()

# ╔═╡ a4a599ce-6362-4b57-a359-0ee1e8d12006
displaysentence()

# ╔═╡ 0f48fb75-ab9d-4ab6-b619-f605e59dd00e
"""Compose HTML representation of current sentence with verbal units
color code."""
function coloredformat()
	groupedtext = ["<blockquote>"]
	global groupidx = 0
	for r in eachrow(assignedtokensdf)
			
		 groupidx = groupidx + 1
		if groupidx == connectorid
				push!(groupedtext, " <span class=\"connector\">$(r.token)</span>")
		else
			
			morph = sentence[groupidx][3]
			if morph == "u--------" # punctuation
				push!(groupedtext, r.token)
				
			elseif r.group == 0
				push!(groupedtext, " <span class=\"unassigned\">$(r.token)</span>")
			else
				coloridx = mod(r.group, length(palette))
				push!(groupedtext, " <span style=\"color: $(palette[coloridx])\">$(r.token)</span>")
				
			end
		end
	end
	push!(groupedtext, "</blockquote>")

	join(groupedtext,"") |> HTML
end;

# ╔═╡ 990de15b-b64f-4830-9740-3d97b93594c4
if step2() == false || nrow(assignedtokensdf) == 0
		md""
else
	coloredformat()
end

# ╔═╡ 7d418f4f-ffb5-4048-8dd2-8535c6d5f664
if step3()
	coloredformat()
end

# ╔═╡ Cell order:
# ╟─2009a8a2-7f18-11ed-32f5-2d0ae7ffdde8
# ╟─a1a1e499-0a67-413b-97a2-6be49eab09bc
# ╟─d227b2f4-5cdd-4ef6-ae7c-0a8f02f1f966
# ╟─44a1635c-41af-450e-b06e-670367ae489b
# ╟─3487cd67-8c0f-4fe0-8c3a-2d25bba023bd
# ╟─b092c825-d4f8-4f3d-a8b1-57a6a642290d
# ╟─8f346da9-00cc-4b3f-8b55-b006bea8bb60
# ╟─7ff0baa8-3354-4300-81bc-90466b049e73
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
# ╟─031d14de-ce21-4d2c-9b1c-9ddbaf59bb01
# ╟─990de15b-b64f-4830-9740-3d97b93594c4
# ╟─7a768206-49a6-44b2-99e3-4448af4fb543
# ╟─4ca90ce5-c1e2-4f35-9e02-81788522c90e
# ╟─3ae3b338-2e05-4a31-aca3-ebc6b71f3d4c
# ╟─85b50b49-584d-4be8-ba33-2d7c72473eb3
# ╟─7d418f4f-ffb5-4048-8dd2-8535c6d5f664
# ╟─5d167ed1-905c-44bd-8b7d-e174f4a0eb04
# ╟─ec6d4eb1-32dc-4dc5-82ab-eafba0540da8
# ╟─a4a599ce-6362-4b57-a359-0ee1e8d12006
# ╟─fe16ab5c-9065-4518-8ac3-38e3506d7633
# ╟─fafa2505-fe2c-4a46-9e43-a54f44e9522f
# ╟─69451dde-a999-4c1f-a8e4-ed731e282149
# ╟─7183fd4d-f180-474f-81d5-524aaf7f0152
# ╟─736baf25-214a-4d22-9003-a4d33155b36e
# ╟─ae140e63-0e4d-4978-b6c2-9f135cac8163
# ╟─9ad3cf28-d403-449e-a8db-cc8a5fe84bee
# ╟─a8e032a5-94f8-4937-aad1-016883116f85
# ╟─b5be20e7-4eec-405b-9aa6-dfbd6aedbecd
# ╟─3a49b461-e4c2-44cb-9600-9ec10bf1e91f
# ╟─d1496b85-c488-4130-a915-aeedfb1e45c0
# ╟─97f0be7b-aafc-4180-a2f3-aa43d2c65358
# ╟─d193df28-4805-49f7-a5ea-c2885be9cd98
# ╟─187adacf-badf-482c-976a-9348e60b4c04
# ╟─fedf66bc-7e15-4a4b-8dab-5aec0f07944e
# ╟─f21fd0c4-602c-4782-908c-3dcd91ad936d
# ╟─86b59bc9-0cbb-4913-a67e-23f19fcd73a4
# ╟─1d76a211-4942-4113-a4ea-13fa9e098168
# ╟─140f25e2-e6b0-47df-a377-c92b3a82c94c
# ╟─14c7b897-8ae7-4f01-94a7-9dfca51ba04f
# ╟─68d9874a-d106-4fbc-8935-82e80cc92f9f
# ╟─419c6fe4-b41f-4045-a2d2-c14a9b255f35
# ╟─1f9b98d9-a7e0-43bf-a651-5e2e3afc85cf
# ╟─a72eeaa5-a54a-4475-868a-1e21eee19b71
# ╟─ca48466c-cd85-456e-ac50-072490cdbc8b
# ╟─03a20740-0756-4081-b2f6-335888238336
# ╟─0635610a-69b0-4a15-b086-236e3fd48a01
# ╟─e7b6a508-81fb-4f40-bd34-185ce6a20e14
# ╟─ab5048e0-e1c4-42ec-8837-a16dd231fe37
# ╟─22415bd0-f22b-4cc8-8b7a-dfaf03c7c228
# ╟─47b1c7b5-3306-45c0-bf14-54c978506b68
# ╟─0f48fb75-ab9d-4ab6-b619-f605e59dd00e
