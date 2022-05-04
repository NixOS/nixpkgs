{ lib
, fetchFromGitHub
, buildDunePackage
, fix
, menhirLib
, menhirSdk
}:

buildDunePackage rec {
  pname = "ocaml-recovery-parser";
  version = "0.2.2";

  minimalOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchFromGitHub {
    owner = "serokell";
    repo = pname;
    rev = version;
    sha256 = "qQHvAPNQBbsvlQRh19sz9BtfhhMOp3uPthVozc1fpw8=";
  };

  propagatedBuildInputs = [
    fix
    menhirLib
    menhirSdk
  ];

  meta = with lib; {
    homepage = "https://github.com/serokell/ocaml-recovery-parser";
    description = "A simple fork of OCaml parser with support for error recovery";
    license = with licenses; [ lgpl2Only mit mpl20 ];
    maintainers = with maintainers; [ romildo ];
  };
}
