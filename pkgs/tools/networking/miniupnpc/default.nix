{ lib
, stdenv
, fetchurl
, cmake
}:

stdenv.mkDerivation rec {
  pname = "miniupnpc";
  version = "2.2.7";

  src = fetchurl {
    urls = [
      "https://miniupnp.tuxfamily.org/files/${pname}-${version}.tar.gz"
      "http://miniupnp.free.fr/files/${pname}-${version}.tar.gz"
    ];
    sha256 = "sha256-sMOicFaED9DskyilqbrD3F4OxtLoczNJz1d7CqHnCsE=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = !stdenv.isFreeBSD;

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    chmod +x $out/lib/libminiupnpc${stdenv.hostPlatform.extensions.sharedLibrary}

    # for some reason cmake does not install binaries and manpages
    # https://github.com/miniupnp/miniupnp/issues/637
    mkdir -p $out/bin
    cp -a upnpc-static $out/bin/upnpc
    cp -a ../external-ip.sh $out/bin/external-ip
    mkdir -p $out/share/man
    cp -a ../man3 $out/share/man
  '';

  meta = with lib; {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = with platforms; linux ++ freebsd ++ darwin;
    license = licenses.bsd3;
    mainProgram = "upnpc";
  };
}
