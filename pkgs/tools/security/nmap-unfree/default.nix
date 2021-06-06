{ lib
, stdenv
, fetchurl
, libpcap
, pkg-config
, openssl
, lua5_3
, pcre
, liblinear
, libssh2
, zlib
, withLua ? true
}:

stdenv.mkDerivation rec {
  pname = "nmap-unfree";
  version = "7.91";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    sha256 = "001kb5xadqswyw966k2lqi6jr6zz605jpp9w4kmm272if184pk0q";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace libz/configure \
        --replace /usr/bin/libtool ar \
        --replace 'AR="libtool"' 'AR="ar"' \
        --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  configureFlags = [
    (if withLua then "--with-liblua=${lua5_3}" else "--without-liblua")
  ];

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.bintools.targetPrefix}ar"
    "RANLIB=${stdenv.cc.bintools.targetPrefix}ranlib"
    "CC=${stdenv.cc.targetPrefix}gcc"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    pcre
    liblinear
    libssh2
    libpcap
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Open source utility for network discovery and security auditing";
    homepage = "http://www.nmap.org";
    # Nmap Public Source License Version 0.93
    # https://github.com/nmap/nmap/blob/master/LICENSE
    license = licenses.unfree;
    maintainers = with maintainers; [ fab SuperSandro2000 ];
  };
}
