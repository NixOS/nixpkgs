{ runCommand, testers }:
let
  sitePkg = runCommand "site" { } ''
    dist=$out/dist
    mkdir -p $dist
    echo "<html><body><a href=\"https://example.com/foo.html\">foo</a><a href=\"https://nixos.org/this-is-ignored.html\">bar</a></body></html>" > $dist/index.html
    echo "<html><body><a href=\".\">index</a></body></html>" > $dist/foo.html
  '';
in testers.lycheeLinkCheck rec {
  site = sitePkg + "/dist";
  remap = { "https://example.com" = site; };
}
