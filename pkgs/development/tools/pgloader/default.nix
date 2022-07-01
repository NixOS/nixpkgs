{ lib, stdenv, fetchurl, makeWrapper, sbcl_2_0_8, sqlite, freetds, libzip, curl, git, cacert, openssl }:
stdenv.mkDerivation rec {
  pname = "pgloader";
  version = "3.6.2";

  src = fetchurl {
    url = "https://github.com/dimitri/pgloader/releases/download/v3.6.2/pgloader-bundle-3.6.2.tgz";
    sha256 = "1jqnw6pw11kwyy8zm2g7g85r8197fy0q4l70yybw9wr87wnqqnz3";
  };

  nativeBuildInputs = [ git makeWrapper ];
  buildInputs = [ sbcl_2_0_8 cacert sqlite freetds libzip curl openssl ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [ sqlite libzip curl git openssl freetds ];

  buildPhase = ''
    export PATH=$PATH:$out/bin
    export HOME=$TMPDIR

    make pgloader
  '';

  dontStrip = true;
  enableParallelBuilding = false;

  installPhase = ''
    install -Dm755 bin/pgloader "$out/bin/pgloader"
    wrapProgram $out/bin/pgloader --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}"
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://pgloader.io/";
    description = "Loads data into PostgreSQL and allows you to implement Continuous Migration from your current database to PostgreSQL";
    maintainers = with maintainers; [ mguentner ];
    license = licenses.postgresql;
    platforms = platforms.all;
  };
}
