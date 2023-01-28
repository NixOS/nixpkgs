{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Uzkz4KEFOf4XdcfkjQm8OQRenUX9jDxTJaRivfIy0ak=";
  };

  cargoHash = "sha256-NbZ9E3vUiDDKyEHZfgS8ErxXhQSTTsoPA/g+kGxCbXc=";

  meta = with lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
