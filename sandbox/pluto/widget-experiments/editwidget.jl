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

# ╔═╡ 214d91fc-8131-11ed-253c-691d5d7eed5d
# ╠═╡ show_logs = false
begin
	using PlutoUI
	import PlutoUI: combine
	using HypertextLiteral
	using DataFrames
	using UUIDs
	using PlutoTeachingTools
	md"""*This cell has the environment.*"""
end

# ╔═╡ 94b8fc4a-a34c-4760-8f18-402368968c29
md"""$(@bind record CounterButton("Add verbal unit to list"))""" |> aside

# ╔═╡ d7e94279-c38d-414d-8f42-765c1899a4cb

function DataFrameInput(data_frame_input, combine_funct; title="")
	
	table_header = []
	table_body = []
	col_names = [@htl("<th>$(col_name)</th>") for col_name in names(data_frame_input)]

	function cell_element(row, cell)
		if isa(cell, Slider) | isa(cell, Scrubbable) | isa(cell, TextField) | isa(cell, RangeSlider) | isa(cell, NumberField) | isa(cell, Select)
			@htl("<td>$(combine_funct(row, cell))</td>")
		else
			@htl("<td>$(cell)</td>")
		end
	end
	
	table_header = @htl("$(col_names)")
	for df_row in eachrow(data_frame_input)
		row_output = [cell_element(string(UUIDs.uuid4()), cell) for cell in df_row]
		table_body = [table_body..., @htl("<tr>$(row_output)</tr>")]
	end
		
	@htl("""
	<h6 style="text-align: center;">$(title)</h6>
	<table>
	<thead>
	<tr>
	$(table_header)
	</tr>
	</thead>
	<tbody>
	$(table_body)
	</tbody>
	</table>
	""")
end

# ╔═╡ 9aa5e582-ce61-4d1c-88d8-16f2144bc5f9
begin
	sems = ["","transitive", "intransitive", "linking"]
	syns = ["", "indepdent clause", "dependent clause", 
	"indirect statement with infinitive",
	"indirect statement with participle",
	"articular infintive",
	"circumstantial participle",
	"attributive participle",
	"quoted",
	"indirect statement"
	]
	vudf = DataFrame(
		:Parameter => ["Syntactic type", "Semantic type", "Depth"],
		
		Symbol("Data Input") => [ Select(syns), Select(sems), NumberField(1:10)],
	)
	
	@bind df_values combine() do Child
		DataFrameInput(vudf, Child; title="Edit a single verbal unit")
	end
end

# ╔═╡ 556a0692-9e08-4612-9bbf-78b307758533
df_values[1]

# ╔═╡ 4dd8c3e0-b358-4465-9339-e3d0c791a063
df_values 

# ╔═╡ ab0e8d5d-a9d9-4613-a009-7dbf87e0fea8
function recordok()
	if isempty(df_values[1]) 
		false
	elseif isempty(df_values[2])
		false
	else
		true
	end
end

# ╔═╡ 1a326cdf-9caf-48d4-9bdc-b16e676a5d6f
vumutable = []

# ╔═╡ c7b1975b-68c1-416d-bb4d-11a407553b31
vumutable

# ╔═╡ a3cc2d1c-6697-45bb-b85c-0c6674ee8823
vurecords = DataFrame(seq = Int[], syn = String[], sem = String[], depth = [])

# ╔═╡ 9c8394e7-7d79-4179-bd07-84a439e80a81
vurecords

# ╔═╡ b75dcaec-0eca-4ccf-a3ed-98d4e26bea5c
begin 
	if record > 0
		if recordok()
			seq = nrow(vurecords) + 1
			push!(vumutable, [seq, df_values[1], df_values[2], df_values[3]])
			md"""Save record $(record)."""
		else
			md"""Missing  a value."""
			
		end
	end
	
end

# ╔═╡ d40dce2e-e8de-452c-b046-1e11ff81ec4b
html"""


<br/><br/><br/><br/><br/><br/>
<h3>Another thing<h3>
"""

# ╔═╡ fba61238-18bb-498d-8fe1-a9bb212de2ca
md"""*Submit row* $(@bind addvurow Button(\"Add verbal unit\")) """

# ╔═╡ a9e371e8-86f6-47c1-a372-7fe0ef3aae95
begin
	syntypemenu = [ "",
		"independent clause",
		"subordinate clause",
		"circumstantial participle",
		"attributive participle",
		"indirect statement with infinitive",
		"indirect statement with participle",
		"quote"
	]
	semtypemenu = ["", "transitive", "intransitive", "linking"]
	vurowdf = DataFrame(
		:Property => ["Refid"],
		Symbol("Value") => [Select(syntypemenu)],
	)

	
	md"""$(@bind rowdf_values combine() do Child
		DataFrameInput(vurowdf, Child; title="Define a verbal unit")
	end)"""
end

# ╔═╡ abda2a1b-9e9f-4772-b48e-b1d3e9541eaa
rowdf_values[1]

# ╔═╡ 3128719c-425f-4316-8c1a-b90a7e0fade5


# ╔═╡ 78e121e7-c7dd-425c-bfef-75c3c64444ad
html"""


<br/><br/><br/><br/><br/><br/>
<h3>Another thing<h3>
"""

# ╔═╡ 30a2cc32-e294-4310-b385-36b860543c9b


# ╔═╡ ec7efeef-49a0-4093-abf5-7edacc200290
#simplevudf = DataFrame(idx = [1], syntype = ["independent clause"], semtype = ["transitive"], level = [1])

# ╔═╡ 4b36b66b-25cf-4ed0-b67f-202238b2af19
#md"""Enter and submit: $(@bind newrowidx NumberField(1:10)) *Submit* $(@bind doit Button(\"Add row\"))"""

# ╔═╡ 1c7c4ad4-afc2-4670-86ee-c23ff76f98a7
begin
	#doit
	#push!(simplevudf,[newrowidx,"New syntype", "New semtype", 0])	
end

# ╔═╡ a22c6fd0-b807-46f8-bfcb-c903167719c7
#=
"""Compose an HTML widget for editing a DataFrame.
Taken unchanged from https://github.com/jeremiahpslewis/PlutoMiscellany.jl/blob/main/notebooks/DataFrameInput_Widget.jl
"""
function DataFrameInput(data_frame_input, combine_funct; title="")
	
	table_header = []
	table_body = []
	col_names = [@htl("<th>$(col_name)</th>") for col_name in names(data_frame_input)]

	function cell_element(row, cell)
		if isa(cell, Slider) | isa(cell, Scrubbable) | isa(cell, TextField) | isa(cell, RangeSlider) | isa(cell, NumberField) | isa(cell, Select)
			@htl("<td>$(combine_funct(row, cell))</td>")
		else
			@htl("<td>$(cell)</td>")
		end
	end
	
	table_header = @htl("$(col_names)")
	for df_row in eachrow(data_frame_input)
		row_output = [cell_element(string(UUIDs.uuid4()), cell) for cell in df_row]
		table_body = [table_body..., @htl("<tr>$(row_output)</tr>")]
	end
		
	@htl("""
	<h6 style="text-align: center;">$(title)</h6>
	<table>
	<thead>
	<tr>
	$(table_header)
	</tr>
	</thead>
	<tbody>
	$(table_body)
	</tbody>
	</table>
	""")
end;
=#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[compat]
DataFrames = "~1.4.4"
HypertextLiteral = "~0.9.4"
PlutoTeachingTools = "~0.2.5"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "330099a9f924f6d79ef97429c1bfc388dc034961"

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

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "3bf60ba2fae10e10f70d53c070424e40a820dac2"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.1.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d4f69885afa5e6149d0cab3818491565cf41446d"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.4.4"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

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

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "82aec7a3dd64f4d9584659dc0b62ef7db2ef3e19"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.2.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "3236cad4ac05408090221fc259f678d913176055"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.19"

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

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

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

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6466e524967496866901a78fca3f2e9ea445a559"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.2"

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

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "96f6db03ab535bdb901300f88335257b0018689d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.2"

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

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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
# ╟─214d91fc-8131-11ed-253c-691d5d7eed5d
# ╟─94b8fc4a-a34c-4760-8f18-402368968c29
# ╠═9c8394e7-7d79-4179-bd07-84a439e80a81
# ╠═c7b1975b-68c1-416d-bb4d-11a407553b31
# ╠═9aa5e582-ce61-4d1c-88d8-16f2144bc5f9
# ╟─d7e94279-c38d-414d-8f42-765c1899a4cb
# ╠═556a0692-9e08-4612-9bbf-78b307758533
# ╠═4dd8c3e0-b358-4465-9339-e3d0c791a063
# ╠═ab0e8d5d-a9d9-4613-a009-7dbf87e0fea8
# ╠═b75dcaec-0eca-4ccf-a3ed-98d4e26bea5c
# ╠═1a326cdf-9caf-48d4-9bdc-b16e676a5d6f
# ╠═a3cc2d1c-6697-45bb-b85c-0c6674ee8823
# ╠═d40dce2e-e8de-452c-b046-1e11ff81ec4b
# ╠═abda2a1b-9e9f-4772-b48e-b1d3e9541eaa
# ╟─fba61238-18bb-498d-8fe1-a9bb212de2ca
# ╠═a9e371e8-86f6-47c1-a372-7fe0ef3aae95
# ╠═3128719c-425f-4316-8c1a-b90a7e0fade5
# ╟─78e121e7-c7dd-425c-bfef-75c3c64444ad
# ╠═30a2cc32-e294-4310-b385-36b860543c9b
# ╠═ec7efeef-49a0-4093-abf5-7edacc200290
# ╠═4b36b66b-25cf-4ed0-b67f-202238b2af19
# ╠═1c7c4ad4-afc2-4670-86ee-c23ff76f98a7
# ╠═a22c6fd0-b807-46f8-bfcb-c903167719c7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
