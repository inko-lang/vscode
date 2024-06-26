VERSION != jq -r .version package.json

build:
	npx @vscode/vsce package

version:
	jq --indent 4 -M '.version = "${VERSION}"' package.json > new.json
	mv new.json package.json

changelog:
	clogs "${VERSION}"

commit:
	git commit package.json package-lock.json CHANGELOG.md -m "Release v${VERSION}"
	git push origin "$$(git rev-parse --abbrev-ref HEAD)"

tag:
	git tag -a -m "Release v${VERSION}" "v${VERSION}"
	git push origin "v${VERSION}"

publish: version changelog commit tag
	npx @vscode/vsce publish

.PHONY: version changelog commit tag publish
