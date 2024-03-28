{ runCommand, testers }:
let
  sitePkg = runCommand "site" { } ''
    dist=$out/dist
    mkdir -p $dist
    echo "<html><body><a href=\"https://example.com/foo.html#butwhere\">foo</a></body></html>" > $dist/index.html
    echo "<html><body><a href=\".\">index</a></body></html>" > $dist/foo.html
  '';

  linkCheck = testers.lycheeLinkCheck {
    site = sitePkg + "/dist";
    remapUrl = "https://example.com";
  };

  failure = testers.testBuildFailure linkCheck;

in
  runCommand "link-check-fail" { inherit failure; } ''
    grep -F butwhere $failure/testBuildFailure.log >/dev/null
    touch $out
  ''
