{ lib, buildNpmPackage, fetchFromGitLab }:

buildNpmPackage rec {
  pname = "antora";
  version = "3.1.5";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PCtYV5jPGFja26Dv4kXiaw8ITWR4xzVP/9hc45UWHeg=";
  };

  npmDepsHash = "sha256-//426AFUoJy7phqbbLdwkJvhOzcYsIumSaeAKefFsf4=";

  # This is to stop tests from being ran, as some of them fail due to trying to query remote repositories
  postPatch = ''
    substituteInPlace package.json --replace \
      '"_mocha"' '""'
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/lib/node_modules/antora-build/packages/cli/bin/antora $out/bin/antora
  '';

  meta = with lib; {
    description = "A modular documentation site generator. Designed for users of Asciidoctor.";
    homepage = "https://antora.org";
    license = licenses.mpl20;
    maintainers = [ maintainers.ehllie ];
  };
}
