### A Pluto.jl notebook ###
# v0.19.16

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

# ╔═╡ dac75c4e-f0b0-4168-91c9-83f4e4332a7b
begin
	using PlutoUI, Kroki, Downloads
	using CitableText
	using PlutoTeachingTools
end

# ╔═╡ a877a321-c20a-438c-84b4-f4d40a76e57f

 css = html"""
<style>
 .connector {
 background: yellow;  
 font-style: bold;
}
 }
</style>
 """

# ╔═╡ 69a3ac2c-7312-11ed-1bbb-afa0ce256496
md"""# Analyze syntax of Lysias 1"""

# ╔═╡ 045e98fc-188f-4c95-bf1c-e102bd4089e5
md"""## 1. Annotate sentence connector"""

# ╔═╡ d7d8d701-4e8a-470e-9d46-035634707e91
md"""$(@bind editvu Button("Edit")) $(@bind deletevu (Button("Delete")))"""

# ╔═╡ 15f25e67-741e-4f6c-9b67-7a87bdd226b6
md"""*Finished identifying verbal units*: $(@bind vudone CheckBox())"""

# ╔═╡ 5007dce1-189c-4bdf-8c99-ffaa84b350cd
html"""

<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>

<hr/>
Below here is WIP
"""

# ╔═╡ c76e37a7-38f7-4f72-8310-b020249a972b
md"""## 3. Assign tokens to verbal units"""

# ╔═╡ 96b2e9da-44b2-4d60-ac1d-00aaf888a889
md"""## 4. Analyze syntax of verbal unit"""

# ╔═╡ 0e15ccf7-e5ab-457b-aae2-9fc069bf3323
md"> Show/hide boolean functions"

# ╔═╡ b0beec77-281d-4d87-b0af-80db1d286b9d
md""">Formatted data that the user doesn't need to see
"""

# ╔═╡ 3f3406af-0d9b-4ae0-adcc-4b652d5dc19f
md"""> Functions to format data and built UI elements
"""

# ╔═╡ b48b3a59-4494-4b9a-8fa2-67f96fae937b
"""Load per-token data from `url`.
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
end

# ╔═╡ ef84f1d8-45a5-4be3-acf2-426677d5073f
# Data triples for each token, grouped by sentence
sentences = loaddata("https://raw.githubusercontent.com/neelsmith/Treebanks.jl/main/lys1tb.cex")

# ╔═╡ 45511e57-7cc2-47b4-8801-0f22f5d1d1a7
md"""Loaded **$(length(sentences))** sentences. 

*Choose a sentence to analyze*: $(@bind sentid Slider(0:length(sentences), show_value  = true))"""

# ╔═╡ ffd206d1-8256-4002-a270-5168aa7d12f3
"""True if requirements for sentence-level annotation (level 1) are satisfied"""
function level1()
	sentid == 0 ? false : true
end

# ╔═╡ b0073fe9-e08d-47cd-ae87-9d9468e50eab
# The currently selected sentence
sentence = sentid == 0 ? [] : sentences[sentid]

# ╔═╡ 103d6511-1878-4070-b546-d6ec17fc889a
if level1()
	md"""*Choose a connecting word from this many initial tokens:* $(@bind ninitial Slider(1:length(sentence), show_value = true, default = 10) )
"""
else 
	md""
end
	

# ╔═╡ 60f71d58-b5cc-4c83-8c69-8b41fd21c8ea
"""Compose menu to select connecting word from first N tokens of current sentence.
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
end

# ╔═╡ 6613a5ac-1ccb-4397-bddc-3c0274d0c563
if level1()
	md"*Connecting word*: $(@bind connectorid Select(connectormenu()))"
else
	md""
end

# ╔═╡ 1eafd8a9-3c07-4901-8a32-ddfaa4d5ed46
"""True if requirements for annotating verbal units (level-2 annotations) are satisfied"""
function level2()
	level1() && ! ismissing(connectorid)
end

# ╔═╡ 50a6569d-189d-4d69-a9fb-36aee1f99c13
if level2()
	md"""## 2. Identify verbal units"""
else
	md""
end
		


# ╔═╡ e4ffd5da-debe-4dde-8cd2-0c74905c886e
verbalunits = begin
	if level2()
		[(id = 1, type = "independent clause", verbtype = missing)]
	else
		md""
	end
end

# ╔═╡ 78392931-eed2-425d-b354-a07a2bb1d2dd
"""Compose menu of verbal units to edit or delete.
"""
function vumenu()
	menu = ["", "Add a new verbal unit"]
	for vu in verbalunits
		push!(menu, string(vu.id, ". ", vu.type))
	end
	menu
end


# ╔═╡ 78714b3d-fa63-431b-b1fa-74855b376def
if level2()
	md"""*Choose a verbal unit*: $(@bind vuchoice Select(vumenu()))"""
	#md""" $(@bind vuchoice Select(vumenu()))"""
	#=
	@bind values PlutoUI.combine() do Child
		md"""*Choose a verbal unit*: $(Child(
				Select(vumenu())
		)
		)
		$(Child(Button("Edit record"))) $(Child(Button("Delete record")))
		"""
	end
	=#
else
	md""
end

# ╔═╡ 9a60b3d9-5712-4f88-8f2a-b2afab8741dc
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
end


# ╔═╡ b2703fbd-a955-418c-bb9b-718fa4410ba0
if ! level1()
	md""
	
elseif ismissing(connectorid)
		str = formatsentence(sentences[sentid])
		HTML("<i>Please identify a connecting word for this sentence, or select <q>asyndeton</q>:</i><br/><blockquote><strong>Sentence $(sentid)</strong>: " * str * "</blockquote>")

elseif isnothing(connectorid)
		str = formatsentence(sentences[sentid])
		HTML("<blockquote><span class=\"connector\">Asyndeton: no connecting word.</span><br/><strong>Sentence $(sentid)</strong>: " * str * "</blockquote>")
else
	
	str = formatsentence(sentences[sentid])
	HTML("<blockquote><strong>Sentence $(sentid)</strong>: " * str * "</blockquote>")
end


# ╔═╡ 81a967b5-0787-442e-84ee-bf0cfb3029df
"""Compose markdown table to display currently defined verbal units."""
function displayvus()
	lines = ["|ID|Type|Verbal type|", "| --- | --- | --- |"]
	for vu in verbalunits
		s = "|$(vu.id)|$(vu.type)|$(vu.verbtype)|"
		push!(lines, s)
	end
	join(lines,"\n")
end

# ╔═╡ cb59838d-f053-4d1a-aee0-e73c514b5aa1
if level2()
	md"""
**Verbal units**

$(displayvus() |> Markdown.parse)
"""
else
	md""
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CitableText = "41e66566-473b-49d4-85b7-da83b66615d8"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
Kroki = "b3565e16-c1f2-4fe9-b4ab-221c88942068"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CitableText = "~0.15.2"
Kroki = "~0.2.0"
PlutoTeachingTools = "~0.2.5"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "32ec95aae9779fa630b24b23bdc6d2945f378e8b"

[[deps.ANSIColoredPrinters]]
git-tree-sha1 = "574baf8110975760d391c710b6341da1afa48d8c"
uuid = "a4c015fc-c6ff-483c-b24f-f7ea428134e9"
version = "0.0.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.CitableBase]]
deps = ["DocStringExtensions", "Documenter", "HTTP", "Test"]
git-tree-sha1 = "80afb8990f22cb3602aacce4c78f9300f67fdaae"
uuid = "d6f014bd-995c-41bd-9893-703339864534"
version = "10.2.4"

[[deps.CitableText]]
deps = ["CitableBase", "DocStringExtensions", "Documenter", "Test"]
git-tree-sha1 = "87c096e67162faf21c0983a29396270cca168b4e"
uuid = "41e66566-473b-49d4-85b7-da83b66615d8"
version = "0.15.2"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "cc4bd91eba9cdbbb4df4746124c22c0832a460d6"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.1.1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[deps.Documenter]]
deps = ["ANSIColoredPrinters", "Base64", "Dates", "DocStringExtensions", "IOCapture", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "REPL", "Test", "Unicode"]
git-tree-sha1 = "6030186b00a38e9d0434518627426570aac2ef95"
uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
version = "0.27.23"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "e1acc37ed078d99a714ed8376446f92a5535ca65"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.5.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "a79c4cf60cc7ddcdcc70acbb7216a5f9b4f8d188"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.16"

[[deps.Kroki]]
deps = ["Base64", "CodecZlib", "DocStringExtensions", "HTTP", "JSON", "Markdown", "Reexport"]
git-tree-sha1 = "a3235f9ff60923658084df500cdbc0442ced3274"
uuid = "b3565e16-c1f2-4fe9-b4ab-221c88942068"
version = "0.2.0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "dedbebe234e06e1ddad435f5c6f4b85cd8ce55f7"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.2.2"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "df6830e37943c7aaa10023471ca47fb3065cc3c4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "b64719e8b4504983c7fca6cc9db3ebc8acc2a4d6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "ea3e4ac2e49e3438815f8946fa7673b658e35bdb"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "dad726963ecea2d8a81e26286f625aee09a91b7c"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.4.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "e4bdc63f5c6d62e80eb1c0043fcc0360d5950ff7"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.10"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═dac75c4e-f0b0-4168-91c9-83f4e4332a7b
# ╟─a877a321-c20a-438c-84b4-f4d40a76e57f
# ╟─69a3ac2c-7312-11ed-1bbb-afa0ce256496
# ╟─045e98fc-188f-4c95-bf1c-e102bd4089e5
# ╟─45511e57-7cc2-47b4-8801-0f22f5d1d1a7
# ╟─103d6511-1878-4070-b546-d6ec17fc889a
# ╟─6613a5ac-1ccb-4397-bddc-3c0274d0c563
# ╟─b2703fbd-a955-418c-bb9b-718fa4410ba0
# ╟─50a6569d-189d-4d69-a9fb-36aee1f99c13
# ╟─15f25e67-741e-4f6c-9b67-7a87bdd226b6
# ╟─78714b3d-fa63-431b-b1fa-74855b376def
# ╟─d7d8d701-4e8a-470e-9d46-035634707e91
# ╟─cb59838d-f053-4d1a-aee0-e73c514b5aa1
# ╟─5007dce1-189c-4bdf-8c99-ffaa84b350cd
# ╟─c76e37a7-38f7-4f72-8310-b020249a972b
# ╟─96b2e9da-44b2-4d60-ac1d-00aaf888a889
# ╟─0e15ccf7-e5ab-457b-aae2-9fc069bf3323
# ╟─ffd206d1-8256-4002-a270-5168aa7d12f3
# ╟─1eafd8a9-3c07-4901-8a32-ddfaa4d5ed46
# ╟─b0beec77-281d-4d87-b0af-80db1d286b9d
# ╟─ef84f1d8-45a5-4be3-acf2-426677d5073f
# ╟─b0073fe9-e08d-47cd-ae87-9d9468e50eab
# ╟─e4ffd5da-debe-4dde-8cd2-0c74905c886e
# ╟─3f3406af-0d9b-4ae0-adcc-4b652d5dc19f
# ╟─b48b3a59-4494-4b9a-8fa2-67f96fae937b
# ╟─78392931-eed2-425d-b354-a07a2bb1d2dd
# ╟─60f71d58-b5cc-4c83-8c69-8b41fd21c8ea
# ╟─9a60b3d9-5712-4f88-8f2a-b2afab8741dc
# ╟─81a967b5-0787-442e-84ee-bf0cfb3029df
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
