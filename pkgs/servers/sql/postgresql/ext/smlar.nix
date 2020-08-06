{ stdenv, fetchgit, postgresql }:

stdenv.mkDerivation rec {
  pname = "smlar-unstable";
  version = "2020-04-08";

  src = fetchgit {
    url = "git://sigaev.ru/smlar.git";
    rev = "0c345af71969d9863bb76efa833391d00705669e";
    sha256 = "1pr3pbnjc9n209l52sgsn4xqzp92qk6wci55hcqjjrwf2gdxy0yr";
  };

  buildInputs = [ postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with stdenv.lib; {
    description = "Compute similary of any one-dimensional arrays";
    homepage = "http://sigaev.ru/git/gitweb.cgi?p=smlar.git";
    platforms = postgresql.meta.platforms;
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
