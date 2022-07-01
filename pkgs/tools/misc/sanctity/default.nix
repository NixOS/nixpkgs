{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "sanctity";
  version = "1.2.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "papojari";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rK4em0maJQS50zPfnuFSxRoXUuFCaw9ZOfmgf70Sdac=";
  };

  cargoSha256 = "sha256-IQp/sSVgKY1j6N+UcifEi74dg/PkZJoeqLekeLc/vMU=";

  meta = with lib; {
    description = "Test the 16 terminal colors in all combinations";
    homepage = "https://codeberg.org/papojari/sanctity";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ papojari ];
  };
}
