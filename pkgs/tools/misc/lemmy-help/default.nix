{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lemmy-help";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "numToStr";
    repo = "lemmy-help";
    rev = "v${version}";
    sha256 = "sha256-gsYVrqPcabLCMYN3Gmr6CXTCKKFAy2rDCxmcRwR1Iic=";
  };

  buildFeatures = [ "cli" ];

  cargoSha256 = "sha256-iyMEzxCTxJ/CP3UEnLc4SN5zhIjCLGUl4OOk0u0bCJc=";

  meta = with lib; {
    description = "A CLI for generating vim help docs from emmylua comments";
    longDescription = ''
      `lemmy-help` is an emmylua parser as well as a CLI which takes that parsed tree and converts it into vim help docs.
    '';
    homepage = "https://github.com/numToStr/lemmy-help";
    changelog = "https://github.com/numToStr/lemmy-help/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
