{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-V+YR0j0Dpmsc2psXb/sb/Rp4Eu8/uuBAkmYTPOfkC+g=";
  };

  cargoHash = "sha256-/xUMfORiZVj5RmDweLCDdD6MkgzCIsTdiYpyO3CDT+M=";

  meta = with lib; {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
