{ fetchFromGitHub, ocamlPackages, lib }:

ocamlPackages.buildDunePackage rec {
  pname = "soupault";
  version = "3.2.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = pname;
    rev = version;
    sha256 = "sha256-T1K/ntCK19LfPmMtaAa9c1JjSL+5dax2SNhM4yUFln4=";
  };

  buildInputs = with ocamlPackages; [
    base64
    containers
    ezjsonm
    fileutils
    fmt
    jingoo
    lambdasoup
    lua-ml
    logs
    markup
    odate
    otoml
    re
    spelll
    tsort
    yaml
  ];

  meta = with lib; {
    description = "A tool that helps you create and manage static websites";
    homepage = "https://soupault.app/";
    license = licenses.mit;
    maintainers = [ maintainers.toastal ];
  };
}

