{ stdenv, fetchurl, makeWrapper, sbcl, sqlite, freetds, libzip, curl, git, cacert, openssl }:
stdenv.mkDerivation rec {
  pname = "pgloader";
  version = "3.6.1";

  src = fetchurl {
    url = "https://github.com/dimitri/pgloader/releases/download/v3.6.1/pgloader-bundle-3.6.1.tgz";
    sha256 = "1sm8xmq30d1biin5br0y3vrv4fydbrzfqglz1hnvrkdyxrg7d6f9";
  };

  nativeBuildInputs = [ git makeWrapper ];
  buildInputs = [ sbcl cacert sqlite freetds libzip curl openssl ];

  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath [ sqlite libzip curl git openssl freetds ];

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

  meta = with stdenv.lib; {
    homepage = https://pgloader.io/;
    description = "pgloader loads data into PostgreSQL and allows you to implement Continuous Migration from your current database to PostgreSQL";
    maintainers = with maintainers; [ mguentner ];
    license = licenses.postgresql;
    platforms = platforms.all;
  };
}
