{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "wal2json";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "wal2json";
    rev = "wal2json_${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-Gpc9uDKrs/dmVSFgdgHM453+TaEnhRh9t0gDbSn8FUI=";
  };

  buildInputs = [ postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension sql/*.sql
  '';

  meta = with lib; {
    description = "PostgreSQL JSON output plugin for changeset extraction";
    homepage = "https://github.com/eulerto/wal2json";
    changelog = "https://github.com/eulerto/wal2json/releases/tag/wal2json_${version}";
    maintainers = with maintainers; [ euank ];
    platforms = postgresql.meta.platforms;
    license = licenses.bsd3;
  };
}
