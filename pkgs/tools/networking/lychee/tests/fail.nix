{ runCommand, testers }:
let
  sitePkg = runCommand "site" { } ''
    dist=$out/dist
    mkdir -p $dist
    echo "<html><body><a href=\"https://example.com/foo.html#foos-missing-anchor\">foo</a></body></html>" > $dist/index.html
    echo "<html><body><a href=\".\">index</a></body></html>" > $dist/foo.html
  '';

  linkCheck = testers.lycheeLinkCheck rec {
    site = sitePkg + "/dist";
    remap = {
      "https://exampl[e]\\.com" = site;
    };
  };

  failure = testers.testBuildFailure linkCheck;

in
runCommand "link-check-fail" { inherit failure; } ''
  grep -F foos-missing-anchor $failure/testBuildFailure.log >/dev/null
  touch $out
''
