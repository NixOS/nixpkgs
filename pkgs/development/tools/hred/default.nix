{ lib, buildNpmPackage, fetchFromGitHub, runCommand, hred, jq }:

buildNpmPackage rec {
  pname = "hred";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "danburzo";
    repo = "hred";
    rev = "v${version}";
    hash = "sha256-rnobJG9Z1lXEeFm+c0f9OsbiTzxeP3+zut5LYpGzWfc=";
  };

  npmDepsHash = "sha256-POxlGWK0TJMwNWDpiK5+OXLGtAx4lFJO3imoe/h+7Sc=";

  dontNpmBuild = true;

  passthru.tests = {
    simple = runCommand "${pname}-test" {} ''
      set -e -o pipefail
      echo '<i id="foo">bar</i>' | ${hred}/bin/hred 'i#foo { @id => id, @.textContent => text }' -c | ${jq}/bin/jq -c > $out
      [ "$(cat $out)" = '{"id":"foo","text":"bar"}' ]
    '';
  };

  meta = {
    description = "A command-line tool to extract data from HTML";
    mainProgram = "hred";
    license = lib.licenses.mit;
    homepage = "https://github.com/danburzo/hred";
    maintainers = with lib.maintainers; [ tejing ];
  };
}
