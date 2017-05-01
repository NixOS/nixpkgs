{ stdenv, fetchFromGitHub, libpcap, sqlite, pixiewps, makeWrapper }:

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

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpcap sqlite pixiewps ];

  sourceRoot = "reaver-wps-fork-t6x-v${version}-src/src";

  configureFlags = "--sysconfdir=${confdir}";

  installPhase = ''
    mkdir -p $out/{bin,etc}
    cp reaver.db $out/etc/
    cp reaver wash $out/bin/

    wrapProgram $out/bin/reaver --run "[ -s ${confdir}/reaver/reaver.db ] || install -D $out/etc/reaver.db ${confdir}/reaver/reaver.db"
    wrapProgram $out/bin/wash   --run "[ -s ${confdir}/reaver/reaver.db ] || install -D $out/etc/reaver.db ${confdir}/reaver/reaver.db"
  '';

  meta = with stdenv.lib; {
    description = "Online and offline brute force attack against WPS";
    homepage = https://github.com/t6x/reaver-wps-fork-t6x;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nico202 volth ];
  };
}
