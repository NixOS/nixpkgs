{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "minesweep-rs";
  version = "6.0.19";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dFY+t6MVRdbp0z5mbnREd/t6v1D+7g/vD+K8mcJvn9E=";
  };

  cargoHash = "sha256-mLRD5Z/ZzfT1BFFSyYmJkY98vMY/Elt3Gy0SboCpzec=";

  meta = with lib; {
    description = "Sweep some mines for fun, and probably not for profit";
    homepage = "https://github.com/cpcloud/minesweep-rs";
    license = licenses.asl20;
    mainProgram = "minesweep";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
