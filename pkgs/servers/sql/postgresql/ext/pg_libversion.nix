 { lib
, stdenv
, fetchFromGitHub
, pkg-config
, postgresql
, libversion
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pg_libversion";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "postgresql-libversion";
    rev = finalAttrs.version;
    hash = "sha256-60HX/Y+6QIzqmDnjNpgO4GCbDhNfeek9myMWoYLdrAA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    postgresql
    libversion
  ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/lib libversion${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control

    runHook postInstall
  '';

  meta = with lib; {
    description = "PostgreSQL extension with support for version string comparison";
    homepage = "https://github.com/repology/postgresql-libversion";
    license = licenses.mit;
    maintainers = [ maintainers.jopejoe1 ];
    platforms = postgresql.meta.platforms;
  };
})

