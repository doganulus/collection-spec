GIT_TAG_LATEST := $(shell git tag --sort=version:refname | tail -n 1)
GIT_TAG_LATEST_STRIPPED := $(shell echo $(GIT_TAG_LATEST) | sed -e "s/^v//")

VERSION_NEXT_PATCH=$(shell echo $(GIT_TAG_LATEST_STRIPPED) | awk -F. '{$$3++; print $$1"."$$2"."$$3}')
VERSION_NEXT_MINOR=$(shell echo $(GIT_TAG_LATEST_STRIPPED) | awk -F. '{$$2++; $$3=0; print $$1"."$$2"."$$3}')
VERSION_NEXT_MAJOR=$(shell echo $(GIT_TAG_LATEST_STRIPPED) | awk -F. '{$$1++; $$2=0; $$3=0; print $$1"."$$2"."$$3}')

MAIN_BRANCH ?= main

bump:
	$(info Latest tag is $(GIT_TAG_LATEST))
	$(info Next patch version is v$(VERSION_NEXT_PATCH) (type 'make patch' to bump))
	$(info Next minor version is v$(VERSION_NEXT_MINOR) (type 'make minor' to bump))
	$(info Next major version is v$(VERSION_NEXT_MAJOR) (type 'make major' to bump))

version-tag-info:
	$(info Latest tag is $(GIT_TAG_LATEST))

patch-info: version-tag-info
	$(info Next patch version is v$(VERSION_NEXT_PATCH) on $(MAIN_BRANCH))

minor-info: version-tag-info
	$(info Next minor version is v$(VERSION_NEXT_MINOR) on $(MAIN_BRANCH))

major-info: version-tag-info
	$(info Next major version is v$(VERSION_NEXT_MAJOR) on $(MAIN_BRANCH))

confirm-question:
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]

patch: patch-info confirm-question
	git tag -a v$(VERSION_NEXT_PATCH) -m "Release: v$(VERSION_NEXT_PATCH)"
	git push origin $(MAIN_BRANCH) --follow-tags

minor: minor-info confirm-question
	git tag -a v$(VERSION_NEXT_MINOR) -m "Release: v$(VERSION_NEXT_MINOR)"
	git push origin $(MAIN_BRANCH) --follow-tags

major: major-info confirm-question
	git tag -a v$(VERSION_NEXT_MAJOR) -m "Release: v$(VERSION_NEXT_MAJOR)"
	git push origin $(MAIN_BRANCH) --follow-tags

.PHONY : bump patch minor major
