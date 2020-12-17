{ stdenv, fetchFromGitHub, util-linux }:

stdenv.mkDerivation rec {
  pname = "mcelog";
  version = "173";

  src = fetchFromGitHub {
    owner  = "andikleen";
    repo   = "mcelog";
    rev    = "v${version}";
    sha256 = "1ili11kqacn6jkjpk11vhycgygdl92mymgb1sx22lcwq2x0d248m";
  };

  postPatch = ''
    for i in mcelog.conf paths.h; do
      substituteInPlace $i --replace /etc $out/etc
    done
    touch mcelog.conf.5 # avoid regeneration requiring Python

    substituteInPlace Makefile --replace '"unknown"' '"${version}"'

    for i in triggers/*; do
      substituteInPlace $i --replace 'logger' '${util-linux}/bin/logger'
    done
  '';

  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" "prefix=" "DOCDIR=/share/doc" ];

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute mcelog.service $out/lib/systemd/system/mcelog.service \
      --replace /usr/sbin $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Log x86 machine checks: memory, IO, and CPU hardware errors";
    longDescription = ''
      The mcelog daemon accounts memory and some other errors in various ways
      on modern x86 Linux systems. The daemon can be queried and/or execute
      triggers when configurable error thresholds are exceeded. This is used to
      implement a range of automatic predictive failure analysis algorithms,
      including bad page offlining and automatic cache error handling. All
      errors are logged to /var/log/mcelog or syslog or the journal.
    '';
    homepage = "http://mcelog.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
