{ lib, stdenv, fetchFromGitHub, perl, jq }:

stdenv.mkDerivation rec {
  pname = "zsv";
  version = "0.3.6-alpha";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    rev = "v${version}";
    hash = "sha256-P4xgWmNPBmuB87jsQvoyuRFCYkD4n/mTd04ZPfaf5ZE=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ jq ];

  configureFlags = [
    "--jq-prefix=${jq.lib}"
  ];

  meta = with lib; {
    description = "World's fastest (simd) CSV parser, with an extensible CLI";
    homepage = "https://github.com/liquidaty/zsv";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
    platforms = platforms.all;
  };
}
