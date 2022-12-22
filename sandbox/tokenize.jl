f = joinpath("sandbox", "lysias1.cex")

using Orthography
using PolytonicGreek
ortho = literaryGreek()

using CitableBase
using CitableCorpus
corpus = fromcex(f, CitableTextCorpus, FileReader)
tokens = tokenize(corpus, ortho)



using CitableText
baseurn = tokens[1][1].urn |> droppassage
finals = [".", ":", ";"]
rangeopener = ""

sentences = []
for n in tokens
    if n[1].text in finals
        rangeu = addpassage(baseurn, string(rangeopener, "-", passagecomponent(n[1].urn)))
        push!(sentences, rangeu)
    elseif isempty(rangeopener)
        rangeopener = passagecomponent(n[1].urn)
    end
end

