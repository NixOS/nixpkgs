{ stdenv, lib, fetchurl, iptables-legacy, libuuid, openssl, pkg-config
, which, iproute2, gnused, coreutils, gawk, makeWrapper
, nixosTests
}:

let
  scriptBinEnv = lib.makeBinPath [ which iproute2 iptables-legacy gnused coreutils gawk ];
in
stdenv.mkDerivation rec {
  pname = "miniupnpd";
  version = "2.3.3";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/miniupnpd-${version}.tar.gz";
    sha256 = "sha256-b9cBn5Nv+IxB58gi9G8QtRvXLWZZePZYZIPedbMMNr8=";
  };

  buildInputs = [ iptables-legacy libuuid openssl ];
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
    inherit (nixosTests) upnp;
  };

  meta = with lib; {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
