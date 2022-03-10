.PHONY: thesis.pdf all clean

all: thesis.pdf

thesis.pdf: thesis.tex
	latexmk

clean:
	latexmk -C
	$(RM) -rf build
	$(RM) -rf "_minted-thesis"
