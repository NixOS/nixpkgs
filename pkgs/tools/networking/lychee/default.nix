{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = version;
    sha256 = "0kpwpbv0dqb0p4bxjlcjas6x1n91rdsvy2psrc1nyr1sh6gb1q5j";
  };

  cargoSha256 = "1b915zkg41n3azk4hhg6fgc83n7iq8p7drvdyil2m2a4qdjvp9r3";

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
