{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libsodium }:

stdenv.mkDerivation rec {
  pname = "minisign";
  version = "0.9";

  src = fetchFromGitHub {
    repo = "minisign";
    owner = "jedisct1";
    rev = version;
    sha256 = "0qx3hnkwx6ij0hgp5vc74x36qfc4h5wgzr70fqqhmv3zb8q9f2vn";
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
