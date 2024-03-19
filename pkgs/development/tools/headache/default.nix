{ lib, fetchFromGitHub, nix-update-script, ocamlPackages }:

let
  inherit (lib) licenses maintainers;
  inherit (ocamlPackages) buildDunePackage camomile;
in

buildDunePackage rec {
  pname = "headache";
  version = "1.07";

  src = fetchFromGitHub {
    owner = "frama-c";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RL80ggcJSJFu2UTECUNP6KufRhR8ZnG7sQeYzhrw37g=";
  };

  propagatedBuildInputs = [
    camomile
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/frama-c/${pname}";
    description = "Lightweight tool for managing headers in source code files";
    mainProgram = "headache";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ niols ];
  };
}
