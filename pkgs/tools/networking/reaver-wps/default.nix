{ stdenv, fetchurl, libpcap, sqlite, makeWrapper }:

stdenv.mkDerivation rec {
  version = "1.4";
  name = "reaver-wps-${version}";
  confdir = "/var/db/${name}"; # the sqlite database is at "${confdir}/reaver/reaver.db"

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/reaver-wps/reaver-${version}.tar.gz";
    sha256 = "0bdjai4p8xbsw8zdkkk43rgsif79x0nyx4djpyv0mzh59850blxd";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpcap sqlite ];

  sourceRoot = "reaver-${version}/src";

  configureFlags = "--sysconfdir=${confdir}";

  installPhase = ''
    mkdir -p $out/{bin,etc}
    cp reaver.db $out/etc/
    cp reaver wash $out/bin/

    wrapProgram $out/bin/reaver --run "[ -s ${confdir}/reaver/reaver.db ] || (mkdir -p ${confdir}/reaver; cp $out/etc/reaver.db ${confdir}/reaver/)"
    wrapProgram $out/bin/wash   --run "[ -s ${confdir}/reaver/reaver.db ] || (mkdir -p ${confdir}/reaver; cp $out/etc/reaver.db ${confdir}/reaver/)"
  '';

  meta = with stdenv.lib; {
    description = "Brute force attack against Wifi Protected Setup";
    homepage = http://code.google.com/p/reaver-wps;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nico202 volth ];
  };
}
