{ stdenv, fetchFromGitHub }:

let version = "122"; in
stdenv.mkDerivation {
  name = "mcelog-${version}";

  src = fetchFromGitHub {
    sha256 = "0g3bp6wfgpjh345n988r2bxzdkbac8mls9v7fsylmfxf78y7n92d";
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
