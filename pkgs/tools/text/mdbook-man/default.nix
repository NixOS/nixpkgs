{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-man";
  version = "unstable-2021-08-26";

  src = fetchFromGitHub {
    owner = "vv9k";
    repo = pname;
    rev = "419c91db0fcfcce65a6006ed9ec8415a8b705186";
    sha256 = "sha256-NOPyDPQms/YJzjkXjVAFR60gLK4zqOuFSdRvFkZRRxQ=";
  };

  cargoSha256 = "sha256-NyeB2vI9Za5T1SKrjqwTi8LXX7A+M+2r/n1u2qtnK5g=";

  meta = with lib; {
    description = "Generate manual pages from mdBooks";
    homepage = "https://github.com/vv9k/mdbook-man";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

