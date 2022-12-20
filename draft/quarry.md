## Outline of modelling Greek syntax

### Sentence

A complete unit of expression. (Don't ask how to find sentences automatically.)

Model a sentence as a *tree of verbal units*.  

Every sentence has at least one *independent* verbal units, expressed with a clause including a finite verb (expressed or implied).  Explicit subjects of finite verbs are always constructed with the nominative case. Multiple independent clauses may be joined in a single sentence by conjunctions.


### Verbal units

A *verbal* unit is a verbal idea with a subject and predicate (either of which might be implicit or explicit).

We annotate the *semantic type* of a verbal expression as one of:

- transitive
- intransitive
- linking

Each independent clause may have zero or more dependent verbal units, comprising constructions like:

- clauses with a finite verb introduced by a subordinating conjunction
- indirect statement with accusative subject + infinitive or participle
- participial verbal unit in either circumstantial or attributive construction, with subject expressed by the substantive that the participle agrees with.  (Supplementary participles are complements to a finite verb and part of its verbal unit, rather than an independent verbal unit.)

Subordinate verbal units may in turn have their own subordinate verbal units, recursively.  For this reason, along with the tokens of the verbal unit, I gather an integer *depth* in the syntax tree.

Within each verbal unit, no matter how it is constructed, the collection of tokens can be analyzed in relations more like Prague style.  Any kind of verbal unit can include the same sorts of objects and adverbial expressions, no matter how the subject and verb are constructed.

## Representing all this


TEXTS:

- an analyzed text has an ordered sequence of uniquely identified *sentences*, expressed as CTS URNs.
- an analyzed text has an expicitly defined *orthography* (otherwise, it can't be identified, only guessed at)


VERBAL UNITS OF A SENTENCE:

- a sentence has an ordered sequence of uniquely identifed verbal units, at a specified depth, with EITHER a specified relation to another verbal unit, OR an identification as the root (head) unit of the sentence.


TOKENS OF A VERBAL UNIT:

- a verbal unit has an ordered sequence of uniquely identified tokens.
- a token has a token-level CTS URN, and a string value
- Tokens are identified a la Kanones with a URN for morphological form and a URN for lexical entity
- tokens of a verbal unit are related in a graph similar to Prague dependency tree banks: they EITHER relate to another token in the verbal unit with a specified relationship OR they are identified as the root (head) token of the verbal unit