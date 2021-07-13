{ lib, stdenv, fetchgit, postgresql }:

stdenv.mkDerivation rec {
  pname = "smlar-unstable";
  version = "2020-10-07";

  src = fetchgit {
    url = "git://sigaev.ru/smlar.git";
    rev = "25a4fef344f5c2b90e6a9d32144ee12b9198487d";
    sha256 = "14mj63mbkcphrzw6890pb5n8igh27i9g7kh4wjdhgx3g7llbjbdw";
  };

  buildInputs = [ postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Compute similary of any one-dimensional arrays";
    homepage = "http://sigaev.ru/git/gitweb.cgi?p=smlar.git";
    platforms = postgresql.meta.platforms;
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
