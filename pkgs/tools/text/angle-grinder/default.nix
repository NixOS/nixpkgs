{ lib, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "angle-grinder";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cGYhGcNalmc/Gr7mY1Fycs8cZYaIy622DFIL64LT+gE=";
  };

  cargoSha256 = "sha256-NkghuZHNT3Rq2wqiyKzjP+u9ZpeHU5H6oBLS0oQ7LcU=";

  meta = with lib; {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
