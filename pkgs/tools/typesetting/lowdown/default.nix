{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.7.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "14mx22aqr9cmin4cyhrclhm0hly1i21j2dmsikfp1c87wl2kpn9xgxnix5r0iqh5dwjxdh591rfh21xjp0l11m0nl5wkpnn7wmq7g6b";
  };

  nativeBuildInputs = [ which ];

  configurePhase = ''
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                MANDIR=''${!outputBin}/share/man
  '';

  meta = with stdenv.lib; {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}

