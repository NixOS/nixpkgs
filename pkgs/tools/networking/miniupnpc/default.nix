{ lib, stdenv, fetchurl, which, cctools }:

let
  generic = { version, sha256 }:
    stdenv.mkDerivation rec {
      pname = "miniupnpc";
      inherit version;
      src = fetchurl {
        url = "https://miniupnp.tuxfamily.org/files/${pname}-${version}.tar.gz";
        inherit sha256;
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
    };
in {
  miniupnpc_2 = generic {
    version = "2.2.4";
    sha256 = "0jrc84lkc7xb53rb8dbswxrxj21ndj1iiclmk3r9wkp6xm55w6j8";
  };
  miniupnpc_1 = generic {
    version = "1.9.20160209";
    sha256 = "0vsbv6a8by67alx4rxfsrxxsnmq74rqlavvvwiy56whxrkm728ap";
  };
}
