{ lib, stdenv, nodejs, fetchFromGitHub, fetchzip, testers, yarn }:

let
  completion = fetchFromGitHub {
    owner = "dsifford";
    repo = "yarn-completion";
    rev = "v0.17.0";
    hash = "sha256-z7KPXeYPPRuaEPxgY6YqsLt9n8cSsW3n2FhOzVde1HU=";
  };
in
stdenv.mkDerivation rec {
  pname = "yarn";
  version = "1.22.19";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
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

  passthru.tests = testers.testVersion { package = yarn; };

  meta = with lib; {
    homepage = "https://yarnpkg.com/";
    description = "Fast, reliable, and secure dependency management for javascript";
    license = licenses.bsd2;
    maintainers = with maintainers; [ offline screendriver ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
