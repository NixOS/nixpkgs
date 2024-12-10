{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  protobufc,
}:

stdenv.mkDerivation rec {
  pname = "cstore_fdw";
  version = "unstable-2022-03-08";

  nativeBuildInputs = [ protobufc ];
  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "cstore_fdw";
    rev = "90e22b62fbee6852529104fdd463f532cf7a3311";
    sha256 = "sha256-02wcCqs8A5ZOZX080fgcNJTQrYQctnlwnA8+YPaRTZc=";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    broken = versionAtLeast postgresql.version "14";
    description = "Columnar storage for PostgreSQL";
    homepage = "https://github.com/citusdata/cstore_fdw";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;
  };
}
