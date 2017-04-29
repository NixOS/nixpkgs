{ stdenv, fetchurl, libpcap, sqlite }:

stdenv.mkDerivation rec {
  version = "1.4";
  name = "reaver-wps-${version}";
  confdir = "/var/db/${name}"; # the sqlite database is at "${confdir}/reaver/reaver.db"

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/reaver-wps/reaver-${version}.tar.gz";
    sha256 = "0bdjai4p8xbsw8zdkkk43rgsif79x0nyx4djpyv0mzh59850blxd";
  };

  buildInputs = [ libpcap sqlite ];

  sourceRoot = "reaver-${version}/src";

  configureFlags = "--sysconfdir=${confdir}";

  installPhase = ''
    mkdir -p $out/{bin,etc,share}
    cp reaver.db $out/etc/

    for prog in reaver wash; do
      cp $prog $out/share/
      cat > $out/bin/$prog <<EOF
    [ -f ${confdir}/reaver/reaver.db ] || (mkdir -p ${confdir}/reaver; cp $out/etc/reaver.db ${confdir}/reaver/)
    exec $out/share/$prog "\$@"
    EOF
      chmod +x $out/bin/$prog
    done
  '';

  meta = {
    description = "Brute force attack against Wifi Protected Setup";
    homepage = http://code.google.com/p/reaver-wps;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
