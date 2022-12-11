{ lib
, stdenv
, fetchurl
, which
, cctools
}:

stdenv.mkDerivation rec {
  pname = "miniupnpc";
  version = "2.2.4";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/${pname}-${version}.tar.gz";
    sha256 = "0jrc84lkc7xb53rb8dbswxrxj21ndj1iiclmk3r9wkp6xm55w6j8";
  };

  nativeBuildInputs = lib.optionals stdenv.isDarwin [ which cctools ];

  patches = lib.optional stdenv.isFreeBSD ./freebsd.patch;

  doCheck = !stdenv.isFreeBSD;

  makeFlags = [ "PREFIX=$(out)" "INSTALLPREFIX=$(out)" ];

  postInstall = ''
    chmod +x "$out"/lib/libminiupnpc${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = with platforms; linux ++ freebsd ++ darwin;
    license = licenses.bsd3;
  };
}
