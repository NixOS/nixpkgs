{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  menhir,
}:

ocamlPackages.buildDunePackage rec {
  pname = "obelisk";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "Lelio-Brun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JJ8k9/6awKZH87T9Ut8x/hlshiUI6sy2fZtY6x2dIIk=";
  };

  strictDeps = true;

  nativeBuildInputs = [ menhir ];
  buildInputs = with ocamlPackages; [ re ];

  meta = {
    description = "Simple tool which produces pretty-printed output from a Menhir parser file (.mly)";
    mainProgram = "obelisk";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/Lelio-Brun/Obelisk";
  };
}
