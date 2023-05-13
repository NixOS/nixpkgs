{ lib
, buildNpmPackage
, fetchurl
, testers
, markdownlint-cli2
}:

let
  source = lib.importJSON ./source.json;
in
buildNpmPackage rec {
  pname = "markdownlint-cli2";
  inherit (source) version;

  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${source.filename}";
    hash = source.integrity;
  };

  npmDepsHash = source.deps;

  postPatch = ''
    # Use generated package-lock.json as upstream does not provide one
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru = {
    tests.version = testers.testVersion {
      package = markdownlint-cli2;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "A fast, flexible, configuration-based command-line interface for linting Markdown/CommonMark files with the `markdownlint` library";
    homepage = "https://github.com/DavidAnson/markdownlint-cli2";
    changelog = "https://github.com/DavidAnson/markdownlint-cli2/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
