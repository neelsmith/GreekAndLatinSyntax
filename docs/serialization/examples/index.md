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
