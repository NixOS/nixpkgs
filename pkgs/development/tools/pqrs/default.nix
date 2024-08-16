{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pqrs";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "pqrs";
    rev = "v${version}";
    sha256 = "sha256-0oSSoGZga0OGAKUNsLmKkUl8N1l0pVi4KIqrKJbeVVU=";
  };

  cargoHash = "sha256-w0WD+EtVGFMGpS4a2DJrLdbunwF2yiONKQwdcQG2EB0=";

  meta = with lib; {
    description = "CLI tool to inspect Parquet files";
    mainProgram = "pqrs";
    homepage = "https://github.com/manojkarthick/pqrs";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };
}
