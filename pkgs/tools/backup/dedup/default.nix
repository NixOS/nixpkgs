{ lib, stdenv, fetchurl, lz4, snappy, libsodium
# For testing
, coreutils, gawk
}:

stdenv.mkDerivation rec {
  pname = "dedup";
  version = "2.0";

  src = fetchurl {
    url = "https://dl.2f30.org/releases/${pname}-${version}.tar.gz";
    sha256 = "0n5kkni4d6blz3s94y0ddyhijb74lxv7msr2mvdmj8l19k0lrfh1";
  };

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX=${placeholder "out"}"
    "MANPREFIX=${placeholder "out"}/share/man"
  ];

  buildInputs = [ lz4 snappy libsodium ];

  doCheck = true;

  nativeCheckInputs = [ coreutils gawk ];
  checkTarget = "test";

  meta = with lib; {
    description = "Data deduplication program";
    homepage = "https://git.2f30.org/dedup/file/README.html";
    license = with licenses; [ bsd0 isc ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
