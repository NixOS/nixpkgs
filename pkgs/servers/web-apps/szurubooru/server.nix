{
  src,
  version,
  lib,
  nixosTests,
  python3,
  ffmpeg-full,
  szurubooru,
}:

python3.pkgs.buildPythonApplication {
  pname = "szurubooru-server";
  inherit version;
  pyproject = true;

  src = "${src}/server";

  nativeBuildInputs = with python3.pkgs; [ setuptools ];
  propagatedBuildInputs = with python3.pkgs; [
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
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg-full ]}"
  ];

  postInstall = ''
    mkdir $out/bin
    install -m0755 $src/szuru-admin $out/bin/szuru-admin
  '';

  passthru.tests.szurubooru = nixosTests.szurubooru;

  # Database migration. Needs the szurubooru server in its environment for the
  # migration to complete successfully.
  passthru.alembic = python3.pkgs.alembic.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      szurubooru.server
    ];
  });
  # Waitress is used to run the serer.
  passthru.waitress = python3.pkgs.waitress.overrideAttrs (old: {
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
