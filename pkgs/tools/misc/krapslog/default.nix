{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "sha256-P/MxIehxj+FE5hvWge7Q2EwL57ObV8ibRZtmko0mphY=";
  };

  cargoSha256 = "sha256-dQDfL5yN2ufFpQCXZ5Il0Qzhb/d7FETCVJg3DOMJPWQ=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
