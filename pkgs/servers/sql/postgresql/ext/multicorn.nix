{ stdenv, fetchFromGitHub, python, postgresql, which }:

stdenv.mkDerivation rec {
  pname = "multicorn";
  version = "1.4.0";

  nativeBuildInputs = [ python which ];
  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "Segfault-Inc";
    repo = "Multicorn";
    rev = "v${version}";
    sha256 = "1sp5cs92w2d6x5jz0gj5nif5ii1fp59djw43idcck4jf20hlxnf7";
  };

  preConfigure = ''
    patchShebangs ./preflight-check.sh
  '';

  installPhase = ''
    install -D multicorn.so                                         -t $out/lib
    install -D {multicorn.control,sql/multicorn{--${version},}.sql} -t $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "PostgreSQL 9.1+ extension meant to make Foreign Data Wrapper development easy";
    homepage = "https://multicorn.org/";
    maintainers = with maintainers; [ bbigras ];
    license = licenses.postgresql;
    inherit (postgresql.meta) platforms;
  };
}
