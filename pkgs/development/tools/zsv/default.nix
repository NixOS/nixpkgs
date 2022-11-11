{ lib, stdenv, fetchFromGitHub, perl, jq }:

stdenv.mkDerivation rec {
  pname = "zsv";
  version = "unstable-2022-11-12";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    rev = "058a990e2086e639d1e11ed8b2ae81b03e4bfcac";
    sha256 = "sha256-V1wkwNSpMsSpaL/j4z4TN59W1+Xn6MYMEWBdwdtTz+s=";
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
