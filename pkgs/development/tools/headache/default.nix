{ lib, fetchFromGitHub, nix-update-script, ocamlPackages }:

let
  inherit (ocamlPackages) buildDunePackage camomile;
in

buildDunePackage rec {
  pname = "headache";
  version = "1.08";

  src = fetchFromGitHub {
    owner = "frama-c";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UXQIIsCyJZN4qos7Si7LLm9vQueOduUmLeYHuyT2GZo=";
  };

  propagatedBuildInputs = [
    camomile
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/frama-c/${pname}";
    description = "Lightweight tool for managing headers in source code files";
    mainProgram = "headache";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ niols ];
  };
}
