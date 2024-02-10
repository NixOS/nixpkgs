{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uZnKrWD3a3TpdKplLxzCKacfpuoo3vrCZmFsePIxR18=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-QaLNc05fI6V/5hbSfOL+uKnjkyxDclAmULx45z9gigs=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
