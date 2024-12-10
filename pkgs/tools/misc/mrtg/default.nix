{
  lib,
  stdenv,
  fetchurl,
  perl,
  gd,
  rrdtool,
}:

let
  perlWithPkgs = perl.withPackages (
    pp: with pp; [
      Socket6
      IOSocketINET6
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "mrtg";
  version = "2.17.10";

  src = fetchurl {
    url = "https://oss.oetiker.ch/mrtg/pub/${pname}-${version}.tar.gz";
    sha256 = "sha256-x/EcteIXpQDYfuO10mxYqGUu28DTKRaIu3krAQ+uQ6w=";
  };

  buildInputs = [
    # add support for ipv6 snmp:
    # https://github.com/oetiker/mrtg/blob/433ebfa5fc043971b46a5cd975fb642c76e3e49d/src/bin/mrtg#L331-L341
    perlWithPkgs
    gd
    rrdtool
  ];

  meta = with lib; {
    description = "The Multi Router Traffic Grapher";
    homepage = "https://oss.oetiker.ch/mrtg/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ robberer ];
    platforms = platforms.unix;
  };
}
