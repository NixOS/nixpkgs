{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fOD28O6ycRIniQz841PGJzEFGtYord/y44mdqyAmNDg=";
  };

  cargoHash = "sha256-r089P2VOeIIW0FjkO4oqVXbrxDND4loagVfVMm5EtaE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # Disabled because they currently fail
  doCheck = false;

  meta = with lib; {
    description = "A fast, async, resource-friendly link checker written in Rust.";
    homepage = "https://github.com/lycheeverse/lychee";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ tuxinaut ];
  };
}
