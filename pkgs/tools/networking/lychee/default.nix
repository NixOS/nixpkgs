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
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GePP4BvOxaLOyF+UNXqcbCtKWeeIcXYIs6zLi+7efVY=";
  };

  cargoSha256 = "sha256-QZDoZNY1ZyWRTeIxRdbTNg5NVDzBtEKGroTzaYRWt1w=";

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
