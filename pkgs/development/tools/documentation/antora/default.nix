{ lib, buildNpmPackage, fetchFromGitLab }:

buildNpmPackage rec {
  pname = "antora";
  version = "3.1.3";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pOEIARvDXc40sljeyUk51DY6LuhVk7pHfrd9YF5Dsu4=";
  };

  npmDepsHash = "sha256-G1/AMwCD2OWuAkqz6zGp1lmaiCAyKIdtwqC902hkZGo=";

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
