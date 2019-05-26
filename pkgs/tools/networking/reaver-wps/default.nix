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


  setSourceRoot = ''
    sourceRoot=$(echo */src)
  '';

  configureFlags = [ "--sysconfdir=${confdir}" ];

  installPhase = ''
    mkdir -p $out/{bin,etc}
    cp reaver.db $out/etc/
    cp reaver wash $out/bin/

    wrapProgram $out/bin/reaver --run "[ -s ${confdir}/reaver/reaver.db ] || install -D $out/etc/reaver.db ${confdir}/reaver/reaver.db"
    wrapProgram $out/bin/wash   --run "[ -s ${confdir}/reaver/reaver.db ] || install -D $out/etc/reaver.db ${confdir}/reaver/reaver.db"
  '';

  meta = with stdenv.lib; {
    description = "Brute force attack against Wifi Protected Setup";
    homepage = https://code.google.com/archive/p/reaver-wps/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nico202 volth ];
  };
}
