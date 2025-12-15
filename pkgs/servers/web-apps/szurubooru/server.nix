{
  src,
  version,
  lib,
  nixosTests,
  fetchPypi,
  python3,
  ffmpeg_4-full,
  szurubooru,
}:

let
  overrides = [
    (self: super: {
      alembic = super.alembic.overridePythonAttrs (oldAttrs: rec {
        version = "1.14.1";
        src = fetchPypi {
          pname = "alembic";
          inherit version;
          sha256 = "sha256-SW6IgkWlOt8UmPyrMXE6Rpxlg2+N524BOZqhw+kN0hM=";
        };
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

  patches = [
    ./001-server-pillow-heif.patch
  ];

  nativeBuildInputs = with python.pkgs; [ setuptools ];
  propagatedBuildInputs = with python.pkgs; [
    certifi
    coloredlogs
    legacy-cgi
    numpy
    pillow
    pillow-heif
    psycopg2-binary
    pynacl
    pyrfc3339
    pytz
    pyyaml
    sqlalchemy
    yt-dlp
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg_4-full ]}"
  ];

  postInstall = ''
    mkdir $out/bin
    install -m0755 $src/szuru-admin $out/bin/szuru-admin
  '';

  passthru.tests.szurubooru = nixosTests.szurubooru;

  # Database migration. Needs the szurubooru server in its environment for the
  # migration to complete successfully.
  passthru.alembic = python.pkgs.alembic.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      szurubooru.server
    ];
  });
  # Waitress is used to run the serer.
  passthru.waitress = python.pkgs.waitress.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      szurubooru.server
    ];
  });

  meta = {
    description = "Server of szurubooru, an image board engine for small and medium communities";
    homepage = "https://github.com/rr-/szurubooru";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ratcornu ];
  };
}
