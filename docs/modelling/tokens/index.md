---
title: "Tokens"
layout: page
nav_order: 6
parent: "Modelling Greek syntax"
---


# Tokens

We model the **contents** of a token as a citable passage identified by a token-level CTS URN with text contents representing a single token.

We **annotate** each token with a token type, and type-dependent morphological and syntactic analyses.

## Token types

Tokens may be one of the following *token types*:

- *lexical*
- *numeric*
- *punctuation*


## Morphological analysis

*Lexical* tokens are further annotated with a morphological identity, expressed with two CITE2 URNs, for the *lexeme* and *morphological form*.

Other token types have a value of `nothing` for morphology.

## Syntactic analysis

The syntactic analysis of tokens is expressed as a graph similar to that of the Prague dependency tree banks.  Each token will identify a *parent token*, and a specific *relation* between the token and the parent token.

In contrast to the Prague model, some tokens will also have a relation to *child token*.

For tokens in dependent verbal units, only one token in each verbal unit will relate to a token in a superior verbal unit.  This token will be the root of the tree of tokens representing that verbal unit. For tokens in an *independent clause*, one token will have a parent relation of `nothing`, and will be the root of the syntax tree for the independent clause.

