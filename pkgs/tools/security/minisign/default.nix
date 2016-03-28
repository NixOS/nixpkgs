{ stdenv, fetchurl, cmake, libsodium }:

stdenv.mkDerivation rec {
  name = "minisign-${version}";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/jedisct1/minisign/archive/${version}.tar.gz";
    sha256 = "029g8ian72fy07k73nf451dw1yggav6crjjc2x6kv4nfpq3pl9pj";
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
  };
}
