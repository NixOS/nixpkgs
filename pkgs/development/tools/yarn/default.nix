{ lib, fetchFromGitHub, fetchzip, nodejs, stdenvNoCC, testers }:

let
  completion = fetchFromGitHub {
    owner = "dsifford";
    repo = "yarn-completion";
    rev = "v0.17.0";
    hash = "sha256-z7KPXeYPPRuaEPxgY6YqsLt9n8cSsW3n2FhOzVde1HU=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yarn";
  version = "1.22.19";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${finalAttrs.version}/yarn-v${finalAttrs.version}.tar.gz";
    sha256 = "sha256-12wUuWH+kkqxAgVYkyhIYVtexjv8DFP9kLpFLWg+h0o=";
  };

  buildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out/{bin,libexec/yarn/,share/bash-completion/completions/}
    cp -R . $out/libexec/yarn
    ln -s $out/libexec/yarn/bin/yarn.js $out/bin/yarn
    ln -s $out/libexec/yarn/bin/yarn.js $out/bin/yarnpkg
    ln -s ${completion}/yarn-completion.bash $out/share/bash-completion/completions/yarn.bash
  '';

  passthru.tests = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "Fast, reliable, and secure dependency management for javascript";
    homepage = "https://classic.yarnpkg.com/";
    changelog = "https://github.com/yarnpkg/yarn/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ offline screendriver marsam ];
    platforms = nodejs.meta.platforms;
    mainProgram = "yarn";
  };
})
