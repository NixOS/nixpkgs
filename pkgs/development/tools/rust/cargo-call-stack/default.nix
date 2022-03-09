{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-call-stack";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "japaric";
    repo = pname;
    rev = "v${version}";
    sha256 = "00ka0yx3114wmpngs44fv2j3r6jxh1v1w9kzzmbklynpi3wmb65b";
  };

  cargoPatches = [ ./add-Cargo-lock.patch ];

  cargoSha256 = "058qfslnxbkhpjmcmssly29aa5w3mpfk18vcvrhpkw1nszgzzln6";

  meta = with lib; {
    description = "Whole program static stack analysis";
    homepage = "https://github.com/japaric/cargo-call-stack";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ glittershark ];
  };
}
