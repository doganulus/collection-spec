GIT_TAG_LATEST := $(shell git tag --sort=version:refname | tail -n 1)
GIT_TAG_LATEST_STRIPPED := $(shell echo $(GIT_TAG_LATEST) | sed -e "s/^v//")

VERSION_NEXT_PATCH=$(shell echo $(GIT_TAG_LATEST_STRIPPED) | awk -F. '{$$3++; print $$1"."$$2"."$$3}')
VERSION_NEXT_MINOR=$(shell echo $(GIT_TAG_LATEST_STRIPPED) | awk -F. '{$$2++; $$3=0; print $$1"."$$2"."$$3}')
VERSION_NEXT_MAJOR=$(shell echo $(GIT_TAG_LATEST_STRIPPED) | awk -F. '{$$1++; $$2=0; $$3=0; print $$1"."$$2"."$$3}')

bump:
	$(info Latest tag is $(GIT_TAG_LATEST))
	$(info Next patch version is v$(VERSION_NEXT_PATCH) (type 'make patch' to bump))
	$(info Next minor version is v$(VERSION_NEXT_MINOR) (type 'make minor' to bump))
	$(info Next major version is v$(VERSION_NEXT_MAJOR) (type 'make major' to bump))

patch:
	git tag -a v$(VERSION_NEXT_PATCH) -m "Release: v$(VERSION_NEXT_PATCH)"
	git push origin main --follow-tags

minor:
	git tag -a v$(VERSION_NEXT_MINOR) -m "Release: v$(VERSION_NEXT_MINOR)"
	git push origin main --follow-tags

major:
	git tag -a v$(VERSION_NEXT_MAJOR) -m "Release: v$(VERSION_NEXT_MAJOR)"
	git push origin main --follow-tags

.PHONY : bump patch minor major
