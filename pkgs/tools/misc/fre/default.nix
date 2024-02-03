{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fre";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "camdencheek";
    repo = "fre";
    rev = version;
    hash = "sha256-nG2+LsmmzAsan3ZjFXGPMz/6hTdj9jiDfgeAwNpu7Eg=";
  };

  cargoHash = "sha256-y0sWe7q5MKebwKObXRgRs348hmjZaklnhYdfUnHoYX0=";

  meta = with lib; {
    description = "A CLI tool for tracking your most-used directories and files";
    homepage = "https://github.com/camdencheek/fre";
    changelog = "https://github.com/camdencheek/fre/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gaykitty ];
  };
}
