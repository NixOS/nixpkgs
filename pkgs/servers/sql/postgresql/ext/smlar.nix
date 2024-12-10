{
  lib,
  stdenv,
  fetchgit,
  postgresql,
}:

stdenv.mkDerivation rec {
  pname = "smlar-unstable";
  version = "2021-11-08";

  src = fetchgit {
    url = "git://sigaev.ru/smlar.git";
    rev = "f2522d5f20a46a3605a761d34a3aefcdffb94e71";
    sha256 = "sha256-AC6w7uYw0OW70pQpWbK1A3rkCnMvTJzTCAdFiY3rO7A=";
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
    maintainers = [ ];
  };
}
