{ lib, stdenv, fetchFromGitHub, pkg-config, curl, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "hcxtools";
  version = "6.1.6";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = pname;
    rev = version;
    sha256 = "sha256-x6sVFjM2GMGqpoAW7CtCLUoEAYLgulaUKXequQ7DmGQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl openssl zlib ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Tools for capturing wlan traffic and conversion to hashcat and John the Ripper formats";
    homepage = "https://github.com/ZerBea/hcxtools";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dywedir ];
  };
}
