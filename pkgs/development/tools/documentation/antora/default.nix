{ lib, buildNpmPackage, fetchFromGitLab }:

buildNpmPackage rec {
  pname = "antora";
  version = "3.1.8";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-d3PkMiOY4fRuwK5UYULY7qY0dnBDWchy1L6fpXaRans=";
  };

  npmDepsHash = "sha256-sZMMIHVMY9usBDyGNFXpUcL7owEk6DvvIGk6U+E9jL4=";

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
    description = "Modular documentation site generator. Designed for users of Asciidoctor";
    mainProgram = "antora";
    homepage = "https://antora.org";
    license = licenses.mpl20;
    maintainers = [ maintainers.ehllie ];
  };
}
