{ stdenv, fetchFromGitHub, utillinux }:

stdenv.mkDerivation rec {
  name = "mcelog-${version}";
  version = "148";

  src = fetchFromGitHub {
    sha256 = "04mzscvr38r2q9da9wmv3cxb99vrkxks1mzgvwsxk753xan3p42c";
    rev = "v${version}";
    repo = "mcelog";
    owner = "andikleen";
  };

  postPatch = ''
    for i in mcelog.conf paths.h; do
      substituteInPlace $i --replace /etc $out/etc
    done
    touch mcelog.conf.5 # avoid regeneration requiring Python

    substituteInPlace Makefile --replace '"unknown"' '"${version}"'

    for i in triggers/*; do
      substituteInPlace $i --replace 'logger' '${utillinux}/bin/logger'
    done
  '';

  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" "prefix=" "DOCDIR=/share/doc" ];

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
    homepage = http://mcelog.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
