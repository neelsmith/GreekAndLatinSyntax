---
title: "Syntactic categories"
layout: page
nav_order: 8
parent: "Modelling Greek syntax"
---

# Syntactic categories



## Top-level annotation

Syntactic annotation is organized by *sentence*,  but expresses how individual sentences connect to their larger context.

The root node of the syntax graph is normally a *connector* — a coordinating conjunction, or a coodinating particle or particles.  Since every sentence includes at least one (explicit or implied) independent clause, and every independent clause includes a verb, the first child token of the *connector* is always one or more verb tokens.  The relation of the verb to the connector is tagged as *unit verb*.

In cases of asyndeton, there is no explicit connector.  In this situation, the unit verbs should be linked to an implied *asyndeton* element.


## Conjunctions

- `conjunction`. Used for 


## Subordinating tokens


- `subordinate conjunction`
- `relative`. Takes two links, first to antecedent, second to function in clause.
- `indirect statement`
- `quoted`
- `indirect statement with infinitive`
- `indirect statement with participle`
- `articular infinitive`
- `circumstantial participle`
- `attributive participle`




## Relations to verbs


The following relations are possible between unit verbs and their children:


- `subject`. Used for an explicit subject.  For finite verbs this will be a nominative form; for indirect statement with an infinitive this will be an accusative form; for circumstantial participles, this will be the substantive that the participle agrees with.
- `object`. Used for direct objects of transitive forms, no matter what the case construction.  Some Greek verbs can have objects in more than one case, e.g., ἀκούω which uses an accusative for a sound or thing that is heard and a genitive for the source, such as a person.
- `adverbial`.  Used for constructions that 
- `dative`
- `direct address`
- `modal particle`
- `complementary infinitive`
- `supplementary participle`


## Relations to substantives

- `attribute`
- `article`
- `pronoun`

## Relations to substantives


- `object of preposition`









