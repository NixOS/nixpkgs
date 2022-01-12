{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libsodium }:

stdenv.mkDerivation rec {
  pname = "minisign";
  version = "0.10";

  src = fetchFromGitHub {
    repo = "minisign";
    owner = "jedisct1";
    rev = version;
    sha256 = "sha256-uqlX4m1e5NTqqyI99j1c6/w/YQWeJC39FufpxAf4JT4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libsodium ];

  meta = with lib; {
    description = "A simple tool for signing files and verifying signatures";
    longDescription = ''
      minisign uses public key cryptography to help facilitate secure (but not
      necessarily private) file transfer, e.g., of software artefacts. minisign
      is similar to and compatible with OpenBSD's signify.
    '';
    homepage = "https://jedisct1.github.io/minisign/";
    license = licenses.isc;
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.unix;
  };
}
