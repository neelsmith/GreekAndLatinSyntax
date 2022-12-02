---
title: "Serialization: examples"
layout: page
nav_order: 6
parent: "Serialization"
---


# Serialization: examples

Consider the following passage of Lysias 1:

> ἐπειδὴ δέ μοι ἡ μήτηρ ἐτελεύτησε, πάντων τῶν κακῶν ἀποθανοῦσα αἰτία μοι γεγένηται.

The data we need to record about it can be represented in the following tables.

To interpret the tables more easily, consult the [visualizations of the same passage](../../visualization/).


## Verbal units and tokens

```
// CEX for a group of verbal units
|vuid|semantic_type|syntactic_type|level|
|---|---|---|---|
|1|intransitive|subordinate_clause|2|
|2|linking|independent_clause|1|
|3|intransitive|circumstantial_participle|2|

// CEX for a group of tokens
|CTSURN|tokentype|nodeid|text|lemma|morphology|parent|relation|verbalunit|
|---|---|---|---|---|---|---|---|
|CTSURN|lexical|51415023|ἐπειδὴ|LEXURN|MORPHURN|5141536|subord.conjunction|1|
|CTSURN|lexical|5141524|δέ|LEXURN|MORPHURN|nothing|root|
|CTSURN|lexical|5141525|μοι|LEXURN|MORPHURN|5141536|dative|1|
|CTSURN|lexical|5141526|ἡ|LEXURN|MORPHURN|5141527|article|1|
|CTSURN|lexical|5141527|μήτηρ|LEXURN|MORPHURN|5141528|subject|1|
|CTSURN|lexical|5141528|ἐτελεύτησε|LEXURN|MORPHURN|51415023|finite verb|1|
|CTSURN|punctuation|5141529|,|nothing|nothing|5141528|punctuation|1|
|CTSURN|lexical|5141530|πάντων|LEXURN|MORPHURN|5141532|attribute|2|
|CTSURN|lexical|5141531|τῶν|LEXURN|MORPHURN|5141532|article|2|
|CTSURN|lexical|5141532|κακῶν|LEXURN|MORPHURN|5141533|genitive
```


## And another

> ἔστι δ’ ἔφη Ἐρατοσθένης Ὀῆθεν ὁ ταῦτα πράττων , ὃς οὐ μόνον τὴν σὴν γυναῖκα διέφθαρκεν ἀλλὰ καὶ ἄλλας πολλάς ·



```
// CEX for a group of verbal units
|vuid|semantic_type|syntactic_type|level|
|---|---|---|---|
|1|intransitive|direct_quote|2|
|2|intransitive|independent_clause|1|
|3|transitive|attributive_participle|3|
|4|transitive|relative|3|
|5|transitive|relative|3|

// CEX for a group of tokens
|CTSURN|tokentype|nodeid|text|lemma|morphology|parent|relation|verbalunit|
|---|---|---|---|---|---|---|---|
|urn:cts:greekLit:tlg0540tlg001.tb:42.16.1|5142026|ἔστι|LEXURN|MORPHURN|5142028|OBJ|
|urn:cts:greekLit:tlg0540tlg001.tb:42.16.2|5142027|δ'|LEXURN|MORPHURN|5142028|root|
|urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142028|ἔφη|φημί|v3siia---|0|PRED
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142029|Ἐρατοσθένης|Ἐρατοσθένης|n-s---mn-|5142028|SBJ
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142030|Ὀῆθεν|Ὀῆθεν|d--------|5142026|ADV
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142031|ὁ|ὁ|l-s---mn-|5142033|ATR
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142032|ταῦτα|οὗτος|a-p---nn-|5142033|OBJ
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142033|πράττων|πράσσω|v-sppamn-|5142029|ATR
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142034|,|,|u--------|5142026|PUNCT
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142035|ὃς|ὅς|p-s---mn-|5142041|SBJ
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142036|οὐ|οὐ|d--------|5142037|AuxZ
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142037|μόνον|μόνον|d--------|5142040|AuxZ
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142038|τὴν|ὁ|l-s---fa-|5142040|ATR
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142039|σὴν|σός|a-s---fa-|5142040|ATR
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142040|γυναῖκα|γυνή|n-s---fa-|5142041|OBJ
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142041|διέφθαρκεν|διαφθείρω|v3sria---|5142029|ATR
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142042|ἀλλὰ|ἀλλά|b--------|5142044|AuxY
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142043|καὶ|καί|b--------|5142044|AuxZ
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142044|ἄλλας|ἄλλος|a-p---fa-|5142040|CO
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142045|πολλάς|πολύς|a-p---fa-|5142044|ATR
urn:cts:greekLit:tlg0540tlg001.tb:42.16|5142046|:|·|u--------|5142026|PUNCT
```
