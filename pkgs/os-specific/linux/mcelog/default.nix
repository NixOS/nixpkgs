{ stdenv, fetchFromGitHub }:

let version = "116"; in
stdenv.mkDerivation {
  name = "mcelog-${version}";

  src = fetchFromGitHub {
    sha256 = "0nr3b924ardz9c1skna8finrjq22ac2vihp3zck9jixc9d5mvrmf";
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
    license = with licenses; gpl2;
    maintainers = with maintainers; [ nckx ];
  };
}
