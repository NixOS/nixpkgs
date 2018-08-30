{ stdenv, fetchMavenArtifact }:

stdenv.mkDerivation rec {
  name = "postgresql-jdbc-${version}";
  version = "42.2.2";

  src = fetchMavenArtifact {
    artifactId = "postgresql";
    groupId = "org.postgresql";
    sha256 = "0w7sfi1gmzqhyhr4iq9znv8hff41xwwqcblkyd9ph0m34r0555hr";
    inherit version;
  };

  phases = [ "installPhase" ];

  installPhase = ''
    install -D $src/share/java/*_postgresql-${version}.jar $out/share/java/postgresql-jdbc.jar
  '';

  meta = with stdenv.lib; {
    homepage = https://jdbc.postgresql.org/;
    description = "JDBC driver for PostgreSQL allowing Java programs to connect to a PostgreSQL database";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
