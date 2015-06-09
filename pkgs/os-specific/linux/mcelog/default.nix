{ stdenv, fetchFromGitHub }:

let version = "118"; in
stdenv.mkDerivation {
  name = "mcelog-${version}";

  src = fetchFromGitHub {
    sha256 = "04hzadxyqlnhjn328bv711lpkipfn5k3gszswydmvvjpis2vhbrr";
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
