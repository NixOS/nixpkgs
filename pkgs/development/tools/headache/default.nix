{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "headache";
  version = "1.06";

  src = fetchFromGitHub {
    owner = "frama-c";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BA7u09MKYMyspFX8AcAkDVA6UUG5DKAdbIDdt+b3Fc4=";
  };

  propagatedBuildInputs = [
    (camomile.override { version = "1.0.2"; })
  ];

  meta = with lib; {
    homepage = "https://github.com/frama-c/${pname}";
    description = "Lightweight tool for managing headers in source code files";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ niols ];
  };
}
