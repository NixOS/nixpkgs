{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bHu3/f25U1QtRZv1z5OQSDMayOpLU6tbNaV00K55ZY8=";
  };

  cargoHash = "sha256-n49VmAJcD98LdkrUCW6ouihSXmSCsdBDvCe9l96G0ec=";

  meta = with lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
