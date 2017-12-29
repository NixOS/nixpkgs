{ stdenv, fetchurl, cmake, zlib, openssl, protobuf, protobufc, lzo, libunwind } :
stdenv.mkDerivation rec {
  name = "zbackup-${version}";
  version = "1.4.4";
  src = fetchurl {
    url = "https://github.com/zbackup/zbackup/archive/1.4.4.tar.gz";
    sha256 = "11csla7n44lg7x6yqg9frb21vnkr8cvnh6ardibr3nj5l39crk7g";
  };
  buildInputs = [ zlib openssl protobuf lzo libunwind ];
  nativeBuildInputs = [ cmake protobufc ];
  meta = {
    description = "A versatile deduplicating backup tool";
    homepage = http://zbackup.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
