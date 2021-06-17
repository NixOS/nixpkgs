{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "db";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "infostreams";
    repo = pname;
    rev = version;
    sha256 = "1apl7v619fgfmafdhi4lf2sg313fycy1sbivwslj5icmbpmrgmy4";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,share/db}
    mv bin db $out/share/db
    ln -s $out/share/db/db $out/bin/db
  '';

  meta = with lib; {
    description = "Version control for databases";
    longDescription = ''
      With DB you can very easily save, restore, and archive snapshots of your
      database from the command line. It supports connecting to different
      database servers (for example a local development server and a staging or
      production server) and allows you to load a database dump from one
      environment into another environment.
    '';
    homepage = "https://github.com/infostreams/db";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
