# Makefile for the Cybersecurity IMT Lucca Beamer template.
#
#  make             Show the available targets
#  make help      Show this help
#  make pdf         Build the presentation into ./$(NAME).pdf
#  make watch       Rebuild continuously on file changes
#  make view        Build, then open the PDF in the default viewer
#  make clean       Remove auxiliary files, keep the PDF
#  make distclean   Remove the build directory and the generated PDF
#  make lint        Check the source with chktex
#  make fmt         Reformat the source with latexindent
#  make ci          Strict build for continuous integration
#  make check-deps  Report which required and optional tools are available
#
# Requires latexmk; run `make check-deps` to verify the toolchain.

# Build main.tex if it exists, otherwise the first .tex in the repository root,
# so a renamed copy of the template still works with a bare `make`.
MAIN     ?= $(firstword $(wildcard main.tex) $(wildcard *.tex))
NAME     := $(basename $(notdir $(MAIN)))
ENGINE   ?= pdflatex
BUILDDIR ?= build

ENGINE_FLAG := $(if $(filter xelatex,$(ENGINE)),-xelatex,\
               $(if $(filter lualatex,$(ENGINE)),-lualatex,-pdf))

# V=1 shows the full TeX log.
QUIET := $(if $(V),,-silent)

# Aux files stay in $(BUILDDIR); success_cmd drops the finished PDF next to the
# source so the usual editor and viewer workflows keep finding it.
LATEXMK = latexmk $(ENGINE_FLAG) $(QUIET) -synctex=1 -outdir=$(BUILDDIR) \
          -interaction=nonstopmode -e '$$success_cmd="cp -f %D %R.pdf"'

OPEN := $(firstword $(shell command -v xdg-open open 2>/dev/null))

MAKEFLAGS += --no-print-directory
.DEFAULT_GOAL := help

.PHONY: help pdf all watch view clean distclean lint fmt ci check-deps

help: ## Show this help
	@printf 'Usage: make <target> [VAR=value]\n\nTargets:\n'
	@grep -hE '^[a-z][a-z-]*:.*## ' $(MAKEFILE_LIST) \
		| sed 's/:.*## /|/' \
		| awk -F'|' '{printf "  \033[36m%-11s\033[0m %s\n", $$1, $$2}'
	@printf '\nVariables:\n'
	@printf '  MAIN=%s\n  ENGINE=%s (pdflatex|xelatex|lualatex)\n  BUILDDIR=%s\n  V=1 for the full TeX log\n' \
		'$(MAIN)' '$(ENGINE)' '$(BUILDDIR)'

all: pdf

pdf: guard-main ## Build the presentation into ./$(NAME).pdf
	@$(LATEXMK) $(MAIN)

watch: guard-main ## Rebuild continuously on file changes
	@$(LATEXMK) -pvc -view=none $(MAIN)

view: pdf ## Build, then open the PDF in the default viewer
ifeq ($(OPEN),)
	@echo "No xdg-open or open found; the PDF is at $(NAME).pdf" >&2
else
	@$(OPEN) $(NAME).pdf
endif

clean: ## Remove auxiliary files, keep the PDF
	@latexmk -c -outdir=$(BUILDDIR) $(MAIN) >/dev/null 2>&1 || true

distclean: ## Remove the build directory and the generated PDF
	@latexmk -C -outdir=$(BUILDDIR) $(MAIN) >/dev/null 2>&1 || true
	@rm -rf $(BUILDDIR) $(NAME).pdf

lint: guard-main ## Check the source with chktex
	@command -v chktex >/dev/null 2>&1 \
		|| { echo "chktex not installed, skipping lint"; exit 0; }
	@chktex -q $(MAIN)

fmt: guard-main ## Reformat the source with latexindent
	@command -v latexindent >/dev/null 2>&1 \
		|| { echo "latexindent not installed, skipping fmt"; exit 0; }
	@mkdir -p $(BUILDDIR)
	@latexindent -w -s -c=$(BUILDDIR) $(MAIN)

ci: guard-main ## Strict build for continuous integration
	@latexmk $(ENGINE_FLAG) -outdir=$(BUILDDIR) -halt-on-error \
		-interaction=nonstopmode $(MAIN)

check-deps: ## Report which required and optional tools are available
	@for t in latexmk $(ENGINE); do \
		command -v $$t >/dev/null 2>&1 \
			&& echo "  ok       $$t" \
			|| echo "  MISSING  $$t (required)"; \
	done
	@for t in chktex latexindent; do \
		command -v $$t >/dev/null 2>&1 \
			&& echo "  ok       $$t" \
			|| echo "  absent   $$t (optional)"; \
	done
	@kpsewhich inter.sty >/dev/null 2>&1 \
		&& echo "  ok       inter.sty" \
		|| echo "  absent   inter.sty (optional, falls back to Latin Modern Sans)"

# Fail with a readable message instead of running latexmk on an empty argument.
guard-main:
ifeq ($(MAIN),)
	@echo "No .tex file found in $(CURDIR); set MAIN=yourfile.tex" >&2
	@exit 1
endif
.PHONY: guard-main
