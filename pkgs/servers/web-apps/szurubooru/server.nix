{
  src,
  version,
  lib,
  fetchPypi,
  python3,
}:

let
  overrides = [
    (self: super: {
      alembic = super.alembic.overridePythonAttrs (oldAttrs: {
        doCheck = false;
      });

      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.23";
        src = fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          sha256 = "sha256-b8ozZyV4Zm9lfBMVUsTviXnBYG5JT3jNUZl0LfsmkYs=";
        };

        doCheck = false;
      });
    })
  ];

  python = python3.override {
    self = python;
    packageOverrides = lib.composeManyExtensions overrides;
  };
in

python.pkgs.buildPythonApplication {
  pname = "szurubooru-server";
  inherit version;
  pyproject = true;

  src = "${src}/server";

  nativeBuildInputs = with python.pkgs; [ setuptools ];
  propagatedBuildInputs = with python.pkgs; [
    alembic
    certifi
    coloredlogs
    heif-image-plugin
    numpy
    pillow-avif-plugin
    pillow
    psycopg2-binary
    pyheif
    pynacl
    pyrfc3339
    pytz
    pyyaml
    sqlalchemy
    yt-dlp
  ];

  postInstall = ''
    mkdir $out/bin
    install -m0755 $src/szuru-admin $out/bin/szuru-admin
  '';

  meta = with lib; {
    description = "Server of szurubooru, an image board engine for small and medium communities";
    homepage = "https://github.com/rr-/szurubooru";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ratcornu ];
  };
}
