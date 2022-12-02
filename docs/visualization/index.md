---
title: "Visualizations"
layout: page
nav_order: 8
---


# Visualization


Here are examples of visualizations of the following passage of Lysias 1:


## Clustered in verbal units

Clustered in verbal units indented by level of subordination:

> **Level 1** (main clause)
>
>> **Level 2** (one level of subordination)
>
>> `unit 1` ἐπειδὴ δέ μοι ἡ μήτηρ ἐτελεύτησε,
>
> `unit 2` πάντων τῶν κακῶν αἰτία μοι γεγένηται.
>
>> `unit 3` ἀποθανοῦσα


## Tokens in document order

All tokens displayed in document order at level of subordination:

> **Level 1** (main clause)
>
>> **Level 2** (one level of subordination)
>
>
>> ἐπειδὴ δέ μοι ἡ μήτηρ ἐτελεύτησε,
>
>  πάντων τῶν κακῶν 
>
>> ἀποθανοῦσα
>
> αἰτία μοι γεγένηται.
 

## Syntax graph

![syntax graph](./syntax.png)

Generated from this mermaid source:
```mermaid
graph BT;

5141536[γεγένηται] -->|finite verb| 5141524[δέ];
5141534[αἰτία] --> |predicate| 5141536[γεγένηται];
5141532[κακῶν] --> |genitive| 5141534[αἰτία];
5141531[τῶν] --> |article| 5141532[κακῶν];
5141530[πάντων] --> |attribute| 5141532[κακῶν];
5141525[μοι] --> |dative| 5141536[γεγένηται];

51415023[ἐπειδὴ] --> |subord.conjunction| 5141536[γεγένηται];

5141528[ἐτελεύτησε] --> |finite verb| 51415023[ἐπειδὴ];
5141527[μήτηρ] --> |subject| 5141528[ἐτελεύτησε] ;
5141526[ἡ] --> |article| 5141527[μήτηρ] ;

5141533[ἀποθανοῦσα] --> |circumstantial participle| 5141527[μήτηρ];

```