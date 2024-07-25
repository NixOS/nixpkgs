{ stdenv
, fetchFromGitHub
, lib
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "pg_rational";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner  = "begriffs";
    repo   = "pg_rational";
    rev    = "v${version}";
    sha256 = "sha256-Sp5wuX2nP3KGyWw7MFa11rI1CPIKIWBt8nvBSsASIEw=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,share/postgresql/extension}

    cp *${postgresql.dlSuffix} $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension

    runHook postInstall
  '';

  meta = with lib; {
    description = "Precise fractional arithmetic for PostgreSQL";
    homepage    = "https://github.com/begriffs/pg_rational";
    maintainers = with maintainers; [ netcrns ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.mit;
  };
}
