{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "minesweep-rs";
  version = "6.0.34";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qYt4LrSQYFr3C0Mkks5aBOYFp60Y3OjFamXxaD5h+mU=";
  };

  cargoHash = "sha256-s2WvRXxEm+/QceHpJA41ZRts6NCcG04kib3L78KwBPg=";

  meta = with lib; {
    description = "Sweep some mines for fun, and probably not for profit";
    homepage = "https://github.com/cpcloud/minesweep-rs";
    license = licenses.asl20;
    mainProgram = "minesweep";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
