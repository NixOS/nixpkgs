{
  lib,
  stdenv,
  fetchFromGitHub,
  apacheHttpd,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "mod_mbtiles";
  version = "unstable-2022-05-25";

  src = fetchFromGitHub {
    owner = "systemed";
    repo = pname;
    rev = "f9d12a9581820630dd923c3c90aa8dcdcf65cb87";
    sha256 = "sha256-wOoLSNLgh0YXHUFn7WfUkQXpyWsgCrVZlMg55rvi9q4=";
  };

  buildInputs = [
    apacheHttpd
    sqlite
  ];

  buildPhase = ''
    apxs -lsqlite3 -ca mod_mbtiles.c
  '';

  installPhase = ''
    runHook preInstall
    install -D .libs/mod_mbtiles.so -t $out/modules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/systemed/mod_mbtiles";
    description = "Serve tiles with Apache directly from an .mbtiles file";
    license = licenses.free;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
