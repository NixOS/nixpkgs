args:
# The homepage says this script is mature..
args.stdenv.mkDerivation {
  name = "mysql2pgsql-0.0.1a";

  src = args.fetchurl {
    url = http://ftp.plusline.de/ftp.postgresql.org/projects/gborg/mysql2psql/devel/mysql2psql-0.0.1a.tgz;
    sha256 = "0dpbxf3kdvpihz9cisx6wi3zzd0cnifaqvjxavrbwm4k4sz1qamp";
  };

  phases = "unpackPhase installPhase";

  buildInputs = with args; [ perl shebangfix ];

  installPhase = ''
    mkdir -p $out/bin;
    shebangfix mysql2psql
    chmod +x mysql2psql
    mv {,$out/bin/}mysql2psql
  '';

  meta = { 
      description = "converts mysql dump files to psql loadable files ";
      homepage = http://pgfoundry.org/projects/mysql2pgsql/;
      license = "GPL";
  };
}
