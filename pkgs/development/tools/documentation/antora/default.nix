{ lib, buildNpmPackage, fetchFromGitLab }:

buildNpmPackage rec {
  pname = "antora";
  version = "3.1.7";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uGXXp6boS5yYsInSmkI9S0Tn85QGVp/5Fsh1u3G4oPk=";
  };

  npmDepsHash = "sha256-oWLRAuvWDk7w18qlDH14EE4elX5nhLKHSQANa/kXKvw=";

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
