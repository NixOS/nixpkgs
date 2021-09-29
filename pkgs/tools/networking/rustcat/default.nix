{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rustcat";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "robiot";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f4g0fk3i9p403r21w1cdz4r9778pkz58y8h7w2fmj27bamsyfhb";
  };

  cargoSha256 = "0zlgnnlnglix0qrjc5v0g91v083lm20iw1fhvjpvjlfq7shdkhyd";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Port listener and reverse shell";
    homepage = "https://github.com/robiot/rustcat";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
