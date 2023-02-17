#!/bin/bash
shopt -s extglob
rm -rf !(gen).go internal LICENSE
mkdir tmp
touch tmp/LICENSE
git fetch https://go.googlesource.com/tools master
git --work-tree=./tmp checkout FETCH_HEAD -- 'LICENSE' 'internal/jsonrpc2_v2/*' 'internal/event' 'internal/stack'
mv tmp/LICENSE tmp/internal/jsonrpc2_v2/* .
rmdir tmp/internal/jsonrpc2_v2
rm -rf internal
mv tmp/internal .
rm -rf internal/stack/gostacks
rmdir tmp
sed -i -r 's#"golang.org/x/tools/internal/jsonrpc2_v2"#"github.com/kortschak/jsonrpc2"#g' *.go
sed -i -r 's#"golang.org/x/tools/internal/#"github.com/kortschak/jsonrpc2/internal/#g' *.go $(find internal -name '*.go')
git reset
if ["$(git diff -- !(gen).go internal LICENSE)" == ""]; then
	>&2 echo no change
	exit 0
fi
git rev-parse FETCH_HEAD > upstream
go test
