{ stdenv, fetchFromGitHub, cmake, libsodium }:

stdenv.mkDerivation rec {
  name = "minisign-${version}";
  version = "0.6";

  src = fetchFromGitHub {
    repo = "minisign";
    owner = "jedisct1";
    rev = version;
    sha256 = "1m71ngxaij3q1dw602kjgj22y5xfjlxrrkjdmx1v4p36y0n6wl92";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libsodium ];

  meta = with stdenv.lib; {
    description = "A simple tool for signing files and verifying signatures";
    longDescription = ''
      minisign uses public key cryptography to help facilitate secure (but not
      necessarily private) file transfer, e.g., of software artefacts. minisign
      is similar to and compatible with OpenBSD's signify.
    '';
    homepage = https://jedisct1.github.io/minisign/;
    license = licenses.isc;
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.unix;
  };
}
