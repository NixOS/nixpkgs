{ lib, stdenv, fetchFromGitHub, perl, jq }:

stdenv.mkDerivation rec {
  pname = "zsv";
  version = "0.3.5-alpha";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    rev = "v${version}";
    hash = "sha256-HW/w2bJVnTELh36rUfGIzAsc6e+PTBGsAdHDz7gFAdI=";
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
