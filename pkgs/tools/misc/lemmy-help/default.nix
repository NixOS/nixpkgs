{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lemmy-help";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "numToStr";
    repo = "lemmy-help";
    rev = "v${version}";
    sha256 = "sha256-VY8sGxS8wwrezTe4ht9xdr4iE2n9fNSNhfCeGDJL5Lo=";
  };

  buildFeatures = [ "cli" ];

  cargoSha256 = "sha256-yj14kg41EqOco0gx79n8xhf8cyotZ1Mxj2AbNV9TImU=";

  meta = with lib; {
    description = "A CLI for generating vim help docs from emmylua comments";
    longDescription = ''
      `lemmy-help` is an emmylua parser as well as a CLI which takes that parsed tree and converts it into vim help docs.
    '';
    homepage = "https://github.com/numToStr/lemmy-help";
    license = with licenses; [ mit ];
  };
}
