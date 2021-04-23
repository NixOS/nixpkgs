{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "03dsp0384mwr51dkqfl25xba0m17sppabiz7slhxcig89b0ksykm";
  };

  cargoSha256 = "08y2wpm2qgm2jsy257b2p2anxy4q3bj2kfdr5cnb6wnaz9g4ypq2";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Disabled because they currently fail
  doCheck = false;

  meta = with lib; {
    description = "A fast, async, resource-friendly link checker written in Rust.";
    homepage = "https://github.com/lycheeverse/lychee";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ tuxinaut ];
    platforms = platforms.linux;
  };
}
