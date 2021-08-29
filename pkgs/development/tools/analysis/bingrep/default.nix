{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ayA3aEidZPa5GJgbbm5K3X2Xgd5Eb6TgUU80Gw/p07w=";
  };

  cargoSha256 = "sha256-XcXllex7UEufV5URhH7aqln1tNxwaiAETO3fUKmHf7s=";

  meta = with lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
