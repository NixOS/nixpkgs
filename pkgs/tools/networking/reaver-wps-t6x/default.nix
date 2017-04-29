{ stdenv, fetchFromGitHub, libpcap, sqlite, pixiewps }:

stdenv.mkDerivation rec {
  version = "1.5.2";
  name = "reaver-wps-t6x-${version}";
  confdir = "/var/db/${name}"; # the sqlite database is at "${confdir}/reaver/reaver.db"

  src = fetchFromGitHub {
    owner = "t6x";
    repo = "reaver-wps-fork-t6x";
    rev = "v${version}";
    sha256 = "0zhlms89ncqz1f1hc22yw9x1s837yv76f1zcjizhgn5h7vp17j4b";
  };

  buildInputs = [ libpcap sqlite pixiewps ];

  sourceRoot = "reaver-wps-fork-t6x-v${version}-src/src";

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
    description = "Online and offline brute force attack against WPS";
    homepage = https://github.com/t6x/reaver-wps-fork-t6x;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainer = stdenv.lib.maintainers.nico202;
  };
}
