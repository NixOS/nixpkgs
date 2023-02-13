{ stdenv, lib, fetchurl, iptables, libuuid, openssl, pkg-config
, which, iproute2, gnused, coreutils, gawk, makeWrapper
, nixosTests
}:

let
  scriptBinEnv = lib.makeBinPath [ which iproute2 iptables gnused coreutils gawk ];
in
stdenv.mkDerivation rec {
  pname = "miniupnpd";
  version = "2.3.1";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/miniupnpd-${version}.tar.gz";
    sha256 = "0crv975qqppnj27jba96yysq2911y49vjd74sp9vnjb54z0d9pyi";
  };

  buildInputs = [ iptables libuuid openssl ];
  nativeBuildInputs= [ pkg-config makeWrapper ];


  # ./configure is not a standard configure file, errors with:
  # Option not recognized : --prefix=
  dontAddPrefix = true;

  installFlags = [ "PREFIX=$(out)" "INSTALLPREFIX=$(out)" ];

  postFixup = ''
    for script in $out/etc/miniupnpd/ip{,6}tables_{init,removeall}.sh
    do
      wrapProgram $script --set PATH '${scriptBinEnv}:$PATH'
    done
  '';

  passthru.tests = {
    bittorrent-integration = nixosTests.bittorrent;
  };

  meta = with lib; {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
