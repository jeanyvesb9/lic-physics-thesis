# Search for new physics through the production of low-mass scalar resonances in *pp* collisions at the LHC with the ATLAS detector

**Original title:** "*Búsqueda de nueva física a través de la producción de resonancias escalares de baja masa en colisiones pp del LHC con el detector ATLAS*"

### Abstract

> Under the validity of certain BSM theories, like models involving Axion-Like particles, during a proton-proton collision at the LHC, a low-mass pseudoscalar resonance <img src="https://render.githubusercontent.com/render/math?math={X}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}X}#gh-dark-mode-only"> can be produced, coupling mainly with third-generation SM particles. These resonances could be detected by ATLAS, produced in association with a pair of top and anti-top quarks, and decaying to a pair of tau leptons, considered to decay hadronically <img src="https://render.githubusercontent.com/render/math?math={(t\bar{t}(X \to \tau_{\text{had}} \tau_{\text{had}}))}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}(t\bar{t}(X \to \tau_{\text{had}} \tau_{\text{had}}))}#gh-dark-mode-only">. The <img src="https://render.githubusercontent.com/render/math?math={X \to \tau_{\text{had}} \tau_{\text{had}}}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}X \to \tau_{\text{had}} \tau_{\text{had}}}#gh-dark-mode-only"> decay channel presents technical difficulties in the range of masses between 20 and 60 GeV since the individual tau leptons can't be resolved in the detector due to a low angular separation. The main challenges in this experimental search are the reconstruction and characterization of the <img src="https://render.githubusercontent.com/render/math?math={X}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}X}#gh-dark-mode-only"> particle's boosted decays for their proper identification, and the estimation of the SM background events that could contaminate the New Physics signal. With these objectives, in this thesis, we will define control and validation regions for the dominant <img src="https://render.githubusercontent.com/render/math?math={t\bar{t}}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}t\bar{t}}#gh-dark-mode-only"> background, estimating the normalization factors by comparing the MC simulations and 2017 data recorded by ATLAS.






## About this project

This repository contains the <img src="https://render.githubusercontent.com/render/math?math={\LaTeX}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}\LaTeX}#gh-dark-mode-only"> code, tables and figures for my Physics Licentiate thesis (equivalent to an M.Sc.) in experimental High Energy Physics at the National University of La Plata (UNLP). All the presented work is part of an ongoing analysis in the ATLAS experiment.

### Requirements:

Any up-to-date <img src="https://render.githubusercontent.com/render/math?math={\LaTeX}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}\LaTeX}#gh-dark-mode-only"> distribution with scientific-oriented packages, like TeXLive, MacTeX or MiKTeX. It can be opened in Overleaf, but only with a premium account due to the <img src="https://render.githubusercontent.com/render/math?math={\sim 100s}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}\sim 100s}#gh-dark-mode-only"> (local) compile time.

### Usage

The project has to be compiled with LuaLaTeX, since it extensively uses the `tikz-feynman` package for generating Feynman Diagrams.

Compile with `latexmk`, or by running `make` inside the repository directory.

### About the template

The format and design of this thesis is based on Edward Tufte's characteristic book design, and Aaron Turon's beautiful PhD thesis.

I began writting the thesis with the `tufte-latex` document-class, but quickly found that I needed to do extensive modifications for it to match the exact look and feel that I wanted. At that point, the easiest path was to write a new `.cls` file, using `memoir` as a base-class, like in [Weimer's thesis](https://github.com/pfasante/phd_thesis).

The current version contains a lot of code inspired in the original `tufte-latex`, and some `classicthesis` code, albeit with many changes. Bibliography management is based Weimer's custom `\cite` commands, although modified to be able to use vertical offsets.

You're free to re-use the thesis' <img src="https://render.githubusercontent.com/render/math?math={\LaTeX}#gh-light-mode-only"><img src="https://render.githubusercontent.com/render/math?math={\color{white}\LaTeX}#gh-dark-mode-only"> template in your own dissertations. I will release a documented and cleaned-up version to CTAN in the future.
