---
title: Index of my blog
keywords: [automata, quantum computing, tensor networks]
date: 2025-05-14
suppress-bibliography: true
thumbnail: "mps-word.png"
theme: math
description:
  Index of my blog
---

\def\Pow{\mathcal{P}}

\def\S{\mathcal{S}}
\def\A{\mathcal{A}}
\def\H{\mathcal{H}}
\def\nStates{A}
\def\nActions{S}
\def\Accepting{\mathcal{F}}

\def\C{\mathbb{C}}
\def\N{\mathbb{N}}

\def\match{\mathtt{match}}

\def\brac#1{\llbracket #1 \rrbracket}
\def\norm#1{\left\lVert#1\right\rVert}


```{=tex}

\usetikzlibrary{chains,shapes.geometric}

\colorlet{sgrey}{gray!80}
\colorlet{sorange}{orange!70}
\colorlet{sgreen}{green!40}
\colorlet{sblue}{green!40}

\definecolor{lightgreen}{HTML}{90EE90}
\definecolor{palegreen}{HTML}{98FB98}
\definecolor{thistle}{HTML}{D8BFD8}

\tikzset{
  tensor/.style = {
    fill = palegreen, draw=black, circle, very thick, minimum size=0.8cm,
  },
  unitary/.style = {
    tensor, rectangle, rounded corners=1pt, fill = thistle
  },
  isometry/.style = {
    unitary,
    trapezium,
    trapezium left angle = 90,
    trapezium right angle = 75,
  },
  vec/.style = {
    tensor,
    node font = \tiny,
    fill = white,
    isosceles triangle,
    isosceles triangle apex angle = 75,
    minimum size = 0.1cm,
    minimum width = 0.5cm,
    inner sep = 0.5mm,
  },
  plug/.style = {
    tensor,
    node font = \tiny,
    fill = white,
    isosceles triangle,
    isosceles triangle apex angle = 75,
    minimum size = 0.2cm,
    inner sep = 0.1mm,
    shape border rotate = #1,
  },
  plug/.default = 0,
  covec/.style = {
    vec,
    shape border rotate = 180,
  },
  tn chain/.style = {
    start chain,
    every on chain/.style=join,
    every join/.style=very thick,
    node distance=5mm,
  },
}
```

You may have noticed from my previous posts that I am really into finite automata (FA).
They exist in an intersection between languages and controllable systems that is simply awesome.
So, as you may have expected from the title, this is yet another post about them.
Our plan today is to take a look at quantum systems and circuits
that measure whether a finite automaton accepts a fixed-size input string.

Quantum states are notoriously hard to represent in a classical computer.
For example, a general quantum computing system with $N$ qubits requires $2^N$ complex coefficients,
which is prohibitively large for even moderately sized $N$.
Thankfully, many of systems that one may encounter in the real world
are describable with much less information.
As we will see, for $N$ characters and an automaton with $A$ symbols and $S$ states,
the relevant quantum systems requires only $O(N A S^2)$ coefficients to represent.
That's an exponential improvement compared to the general case.

In the course of this post,
we also explore different forms of representing FAs.
Namely, as vectors, tensor networks and quantum circuits.
Also, besides the obvious prerequisites on tensors and automata,
a bit of familiarity with [Bra-ket notation](https://en.wikipedia.org/wiki/Bra%E2%80%93ket_notation)
and String Diagrams will be useful for understanding this post.
Nevertheless, I'll try to introduce any new concept as needed.
Please drop a message if you find anything to be missing or confusing!

