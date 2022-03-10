# Search for new physics through the production of low-mass scalar resonances in ![formula](https://render.githubusercontent.com/render/math?math=pp) collisions at the LHC with the ATLAS detector

**Original title:** "_Búsqueda de nueva física a través de la producción de resonancias escalares de baja masa en colisiones pp del LHC con el detector ATLAS_"

### Abstract

> Under the validity of certain BSM theories, like models involving Axion-Like particles, during a proton-proton collision at the LHC, a low-mass pseudoscalar resonance ![formula](https://render.githubusercontent.com/render/math?math=X) can be produced, coupling mainly with third-generation SM particles. These resonances could be detected by ATLAS, produced in association with a pair of top and anti-top quarks, and decaying to a pair of tau leptons, considered to decay hadronically ![formula](https://render.githubusercontent.com/render/math?math=(t\bar{t}(X%20\to%20\tau_{\text{had}}%20\tau_{\text{had}}))). The ![formula](https://render.githubusercontent.com/render/math?math=X%20\to%20\tau\tau) decay channel presents technical difficulties in the range of masses between 20 and 60 GeV since the individual tau leptons can't be resolved in the detector due to a low angular separation. The main challenges in this experimental search are the reconstruction and characterization of the ![formula](https://render.githubusercontent.com/render/math?math=X) particle's boosted decays for their proper identification, and the estimation of the SM background events that could contaminate the New Physics signal. With these objectives, in this thesis, we will define control and validation regions for the dominant ![formula](https://render.githubusercontent.com/render/math?math=t\bar{t}) background, estimating the normalization factors by comparing the MC simulations and 2017 data recorded by ATLAS.






## About this project

This repository contains the ![formula](https://render.githubusercontent.com/render/math?math=\LaTeX) code, tables and figures for my Physics Licentiate thesis (equivalent to an M.Sc.) in experimental High Energy Physics at the National University of La Plata (UNLP). All the presented work is part of an ongoing analysis in the ATLAS experiment.

### Requirements:

Any up-to-date ![formula](https://render.githubusercontent.com/render/math?math=\LaTeX) distribution with scientific-oriented packages, like TeXLive, MacTeX or MiKTeX. It can be opened in Overleaf, but only with a premium account due to the ![formula](https://render.githubusercontent.com/render/math?math=\sim%20100s) (local) compile time.

### Usage

The project has to be compiled with LuaLaTeX, since it extensively uses the `tikz-feynman` package for generating Feynman Diagrams.

Compile with `latexmk`, or by running `make` inside the repository directory.

### About the template

The format and design of this thesis is based on Edward Tufte's characteristic book design, and Aaron Turon's beautiful PhD thesis.

I began writting the thesis with the `tufte-latex` document-class, but quickly found that I needed to do extensive modifications for it to match the exact look and feel that I wanted. At that point, the easiest path was to write a new `.cls` file, using `memoir` as a base-class, like in [Weimer's thesis](https://github.com/pfasante/phd_thesis).

The current version contains a lot of code inspired in the original `tufte-latex`, and some `classicthesis` code, albeit with many changes. Bibliography management is based Weimer's custom `\cite` commands, although modified to be able to use vertical offsets.

You're free to re-use the thesis' ![formula](https://render.githubusercontent.com/render/math?math=\LaTeX) template in your own dissertations. I will release a documented and cleaned-up version to CTAN in the future.
