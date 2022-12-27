### A Pluto.jl notebook ###
# v0.19.18

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

# ╔═╡ c91e9345-9a42-4418-861b-6cdda203a71e
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate(".")
	Pkg.instantiate()
	Pkg.add("PlutoUI")
	using PlutoUI
	Pkg.add("PlutoTeachingTools")
	using PlutoTeachingTools
	Pkg.add("Kroki")
	using Kroki
	Pkg.add("CitableText")
	using CitableText
	Pkg.add(url = "https://github.com/neelsmith/GreekSyntax.jl")
	using GreekSyntax
	md"""*Unhide this cell to see environment configuration.*"""
end

# ╔═╡ 371a795c-80a2-4bd7-97fa-d3e908a0dee0
TableOfContents() 

# ╔═╡ 6791a277-05ea-43d6-9710-c4044f0c178a
nbversion = "0.0.1";

# ╔═╡ 282716c0-e0e4-4433-beb4-4b988fddaa9c
md"""(*Notebook version **$(nbversion)**.*)  *See version history* $(@bind history CheckBox())"""

# ╔═╡ a4946b0e-17c9-4f90-b820-2439047f2a6a
if history
	md"""
- **0.0.1**: initial release	
	"""
end

# ╔═╡ e7059fa0-82f2-11ed-3bfe-059070a00b1d
md"""## Read Greek with syntactic annotations
"""

# ╔═╡ b9311908-9282-4658-95ab-6e1ff0ebb84f
md"""### Load data set"""

# ╔═╡ 4ee3feb0-8ba2-4649-8f13-94f952ec8883
begin
	defaultdir = joinpath(pwd(), "output")
	md"""*Source directory*: $(@bind basedir confirm(TextField(80; default = defaultdir)))"""
end

# ╔═╡ 255d6736-08d5-4565-baef-f3b6f4d433e1
begin
	cexfiles = filter(readdir(basedir)) do fname
		endswith(fname, ".cex")
	end
	datasets = [""]
	for f in cexfiles
		push!(datasets,f)
	end
	md"""*Choose a dataset* $(@bind dataset Select(datasets))"""
end


# ╔═╡ 2c692039-dd5b-4430-9f2e-d9eaa8851fbf
md"""*Include syntax diagram* $(@bind diagram CheckBox(true))
"""

# ╔═╡ 37543f05-bdfa-4cb5-9514-ae5a5b10819d
"""Compose Mermaid diagramd for syntax dataframe `syndf`."""
function mermadize(tknlist)
	graphlines = [
		"graph BT;",
		"classDef implicit fill:#f96,stroke:#333;"
	]
	lexlist = filter(t -> t.tokentype == "lexical", tknlist)

	for (nodeidx, tkn) in enumerate(lexlist)
		
		if tkn.node1 == "nothing"
			#skip
		else
			if tkn.text == "implied" 
				push!(graphlines, "class $(nodeidx) implicit;")
			end
			node1int = parse(Int, tkn.node1)
			if node1int != 0
				push!(graphlines, string(
				nodeidx, 
				"[", tkn.text, "]", 
				" --> |", tkn.node1relation, "| ", tkn.node1,
				"[", tknlist[node1int].text, "];"))
			end
			
			#if ! isnothing(asynidx) && string(asynidx) == r.node1
			#	push!(graphlines, "class $(r.node1) implicit;")
			#end
			
			if  isnothing(tkn.node2) || isempty(tkn.node2relation)
			else
				#push!(graphlines, string(r.reference, "[", r.token, "]", " --> |", r.node2rel, "| ", r.node2, "[", syndf[parse(Int, r.node2), :token], "];"))
			end
		end
		
	end
	#asynidx = asyndetonidx(syndf)

	#=
	# global 
	for r in eachrow(syndf)
		 
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
			if  isnothing(r.node2) || isempty(r.node2)
			else
				push!(graphlines, string(r.reference, "[", r.token, "]", " --> |", r.node2rel, "| ", r.node2, "[", syndf[parse(Int, r.node2), :token], "];"))
			end
			
		end
	end
	=#
	graphstr = join(graphlines, "\n")
end;

# ╔═╡ a4265158-2df5-4d62-a38c-5395505004f3
md"""## Read cited passage


**TBA**
"""

# ╔═╡ 34f55f22-1115-4962-801f-bde4edca05f3
html"""
<br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/>
<hr/>
"""

# ╔═╡ ec7eb05f-fd6d-4477-a80b-9bfe1fe02fac
md"""> ## CSS and visual styling"""

# ╔═╡ 3954a240-fb4f-4371-bf17-5644c049582f
md"""
### CSS used


#### On `div`
- `class="passage"`


#### On `span`

Class attributes:

- `connector`
- `subject`
- `verb`
- `object`

Also on `span`: colors directly set in `style` attribute for verbal groups.
"""

# ╔═╡ 9ed6aaaf-fba8-4101-9a6c-48215f4ec3f9
 css = html"""
<style>
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
 """

# ╔═╡ 87e46deb-aaad-4e78-81e9-410e3dda062d
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
]

# ╔═╡ 136599a5-b7c1-4513-be88-e7e79e1f6fb5
md"""> ## File management"""

# ╔═╡ 74ec2148-dd53-4f54-9d92-327d5ba44eaf
(sentences, verbalunits, tokens) = parsedelimited(readlines(joinpath(basedir, dataset)))


# ╔═╡ 20f31f23-9d89-47d3-85a3-b53b5bc67a9f
"""True if selected dataset exists."""
function dsexists()
	! isempty(sentences)
end

# ╔═╡ 31ea4680-63ff-44fc-82cf-dadb041fd144
if isempty(dataset)
	md"""*Please choose a dataset*"""
else
	if dsexists()
		md"""*Summary*:  **$(length(sentences)) sentences** with **$(length(verbalunits)) verbal units** composed from **$(length(tokens)) tokens**."""
		
	else
		md"Something is broken"
	end
end

# ╔═╡ 185edebe-b458-436e-91e7-3db8703991bf
if dsexists()
	md"""## Read by sentence"""
end

# ╔═╡ 32048e21-b1eb-49f1-94e6-c5347331f727
if dsexists()
	sentencemenu = [""]
	for s in sentences 
		push!(sentencemenu, passagecomponent(s.range))
	end
	md"""*Choose a sentence* $(@bind sentchoice Select(sentencemenu)) 
	"""
end

# ╔═╡ deb8fb9d-407f-4bc8-9690-92934e5751e1
if dsexists()
	displaymenu = ["continuous" => "continuous text", "indented" => "indented for subordination"
	]
	md"""*Display* $(@bind txtdisplay Select(displaymenu)) *Highlight SOV+ functions* $(@bind sov CheckBox()) *Color verbal units* $(@bind vucolor CheckBox()) *Add tooltips* $(@bind tippy CheckBox())
"""
end

# ╔═╡ 1efb3f4c-13a7-4e71-a2f0-fdd9a057f37c
if !isempty(dataset) && sov
	colorkey = """<p>Key to SOV+ highlighting:</p><ul>
	<li><span class="connector">sentence connector</span></li>
	<li><span class="verb">unit verb</span></li>
	<li><span class="subject">subject of unit verb</span></li>
	<li><span class="object">object of unit verb</span></li>
	</ul>
	"""
	tip(HTML(colorkey))
end

# ╔═╡ 6ea61036-4276-4e65-899f-9dddf1d32475
	if !isempty(dataset) && tippy
		tipwarn = "<p/><p><i>NB: Tool tips not yet implemented</p>"
		HTML(tipwarn) |> almost
	end

# ╔═╡ a8fea22e-e8c4-414f-b039-303a882601d0
md"""> ## Functions to move to `GreekSyntax.jl`"""

# ╔═╡ dc396721-d1fa-4c12-a914-295db44b2ac5
"""Extract sentence range from verbal unit identifier."""
function sentenceforvu(ref)
	re = r"\.[^.]$"
	replace(ref, re => "")
end

# ╔═╡ 5c9376cf-9722-4c94-bacb-30584a724354
"""Select tokens from `tokenlist` that belong to sentence
identifeid by `sentref`.
"""
function tokensforsentence(sentref, tokenlist)
	filter(tokenlist) do tkn
		startswith(tkn.verbalunit, sentref * ".")
	end
end

# ╔═╡ 809e4588-4d79-4a6d-a0e7-625805fc73d7
begin
	if diagram
		graphstr = tokensforsentence(sentchoice, tokens) |> mermadize
		mermaid"""$(graphstr)"""
	end
end

# ╔═╡ b0208fd5-b153-4eef-a1ec-46fadd50401c
function sentenceforpsg(psg, slist)
	matches = filter(s -> passagecomponent(s.range) == psg, slist)
	if length(matches) >  1
		@error("Multiple matches for $(psg)")
	elseif length(matches) == 1
		matches[1]		
	else
		nothing
	end
end

# ╔═╡ 39176b7d-ca56-459e-a58f-ca508e9b5c4e
function groupcolorfortoken(vuref, colors)
	re = r".+\."
	if endswith(vuref, "nothing")
		""
	else
		replace(vuref, re => "")
		digits = replace(vuref, re => "")
		if digits == "0"
			""
		else
			idx = parse(Int, digits) 
			modded = mod(length(colors), idx) + 1
			"style=\"color: $(colors[modded])\""
		end
	end
end

# ╔═╡ b615011c-90f8-4e42-be41-58ba0fc71316
function classesfortoken(t, conn)
	opts = []
	if t.urn == conn
		push!(opts, "connector")
	end
	rel1 = lowercase(t.node1relation)
	if rel1 == "subject"
		push!(opts, "subject")
		
	elseif rel1 == "object"
		push!(opts, "object")
		
	elseif rel1 == "unit verb"
		push!(opts, "verb")
	end
		
	string("class=\"", join(opts, " "), "\"")
end

# ╔═╡ 6e9fba3e-e921-4e63-952f-107ce6861588
"""Format sentence identified by `psg`, using vectors of
sentence annotations `s`, verbalunit annotations `v` and
token annotations `t`.
"""
function formatsentence(psg, s,v,t)
	connection = sentenceforpsg(psg,s).connector
	tkns = tokensforsentence(psg, t)
	outputlist = ["<div class=\"passage\">"]


	
	
	tips = []
	for t in tkns
		if t.tokentype == "punctuation"
			push!(outputlist, t.text)
		else
			
			classes = sov ? classesfortoken(t, connection) : ""
			styles = vucolor ? groupcolorfortoken(t.verbalunit, palette) : ""
				
			push!(outputlist, " <span $(classes) $(styles)>" * t.text * "</span>")

		end
	end
	
	
	push!(outputlist,"</div>")

		
	join(outputlist, "")
	
end

# ╔═╡ c26d95cb-e681-43e0-acc7-e4af4bf5e0da
begin
	if isempty(dataset) 
	elseif isempty(sentchoice)
	else
		if txtdisplay == "continuous"
			hdr = "<h4>Passage: $(sentchoice)</h4>"
			formatted = formatsentence(sentchoice, sentences, verbalunits, tokens)
			HTML(hdr * formatted * "<p/>")
			
		else
			almost(md"""Formatting for option *$(txtdisplay) display* not yet implemented.""")
		end
	end
end

# ╔═╡ Cell order:
# ╟─371a795c-80a2-4bd7-97fa-d3e908a0dee0
# ╟─6791a277-05ea-43d6-9710-c4044f0c178a
# ╟─c91e9345-9a42-4418-861b-6cdda203a71e
# ╟─282716c0-e0e4-4433-beb4-4b988fddaa9c
# ╟─a4946b0e-17c9-4f90-b820-2439047f2a6a
# ╟─e7059fa0-82f2-11ed-3bfe-059070a00b1d
# ╟─b9311908-9282-4658-95ab-6e1ff0ebb84f
# ╟─4ee3feb0-8ba2-4649-8f13-94f952ec8883
# ╟─255d6736-08d5-4565-baef-f3b6f4d433e1
# ╟─31ea4680-63ff-44fc-82cf-dadb041fd144
# ╟─185edebe-b458-436e-91e7-3db8703991bf
# ╟─32048e21-b1eb-49f1-94e6-c5347331f727
# ╟─deb8fb9d-407f-4bc8-9690-92934e5751e1
# ╟─c26d95cb-e681-43e0-acc7-e4af4bf5e0da
# ╟─1efb3f4c-13a7-4e71-a2f0-fdd9a057f37c
# ╟─6ea61036-4276-4e65-899f-9dddf1d32475
# ╟─2c692039-dd5b-4430-9f2e-d9eaa8851fbf
# ╟─809e4588-4d79-4a6d-a0e7-625805fc73d7
# ╟─37543f05-bdfa-4cb5-9514-ae5a5b10819d
# ╟─a4265158-2df5-4d62-a38c-5395505004f3
# ╠═34f55f22-1115-4962-801f-bde4edca05f3
# ╟─ec7eb05f-fd6d-4477-a80b-9bfe1fe02fac
# ╟─3954a240-fb4f-4371-bf17-5644c049582f
# ╟─9ed6aaaf-fba8-4101-9a6c-48215f4ec3f9
# ╟─87e46deb-aaad-4e78-81e9-410e3dda062d
# ╟─136599a5-b7c1-4513-be88-e7e79e1f6fb5
# ╠═74ec2148-dd53-4f54-9d92-327d5ba44eaf
# ╟─20f31f23-9d89-47d3-85a3-b53b5bc67a9f
# ╟─a8fea22e-e8c4-414f-b039-303a882601d0
# ╟─dc396721-d1fa-4c12-a914-295db44b2ac5
# ╠═5c9376cf-9722-4c94-bacb-30584a724354
# ╠═b0208fd5-b153-4eef-a1ec-46fadd50401c
# ╠═39176b7d-ca56-459e-a58f-ca508e9b5c4e
# ╠═b615011c-90f8-4e42-be41-58ba0fc71316
# ╠═6e9fba3e-e921-4e63-952f-107ce6861588
