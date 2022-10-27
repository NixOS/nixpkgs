{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "dabet";
  version = "3.0.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B5z2RUkvztnGCKeVsjp/yzrI8m/6mjBB0DS1yhFZhM4=";
  };

  cargoSha256 = "sha256-v1lc2quqxuNUbBQHaTtIDUPPTMyz8nj+TNCdSjrfrOA=";

  meta = with lib; {
    description = "Print the duration between two times";
    homepage = "https://codeberg.org/annaaurora/dabet";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
  };
}

