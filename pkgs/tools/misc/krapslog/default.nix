{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "sha256-GSjS/6wetm3kHXdGyeenzALZ3tVi7BMM/GLS1ZhMQas=";
  };

  cargoHash = "sha256-dgbi0mUI8WqqXF1VNOTbHuCKcvb4B18/1vBlJZ8Jivs=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
