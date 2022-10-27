{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nbtscanner";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "jonkgrimes";
    repo = pname;
    rev = version;
    sha256 = "06507a8y41v42cmvjpzimyrzdp972w15fjpc6c6750n1wa2wdl6c";
  };

  cargoSha256 = "0cis54zmr2x0f4z664lmhk9dzx00hvds6jh3x417308sz7ak11gd";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "NetBIOS scanner written in Rust";
    homepage = "https://github.com/jonkgrimes/nbtscanner";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
