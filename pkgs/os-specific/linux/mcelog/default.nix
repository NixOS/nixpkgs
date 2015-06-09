{ stdenv, fetchFromGitHub }:

let version = "119"; in
stdenv.mkDerivation {
  name = "mcelog-${version}";

  src = fetchFromGitHub {
    sha256 = "04zm8pa7r6awjgza8m048srvqcyayzdzw93vl8yrjzhh37p5m4gp";
    rev = "v${version}";
    repo = "mcelog";
    owner = "andikleen";
  };

  postPatch = ''
    for i in mcelog.conf paths.h; do
      substituteInPlace $i --replace /etc $out/etc
    done
    touch mcelog.conf.5 # avoid regeneration requiring Python
  '';

  installFlags = "DESTDIR=$(out) prefix= DOCDIR=/share/doc";

  meta = with stdenv.lib; {
    inherit version;
    description = "Log machine checks (memory, IO, and CPU hardware errors)";
    homepage = http://mcelog.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nckx ];
  };
}
