{ stdenv, makeWrapper, requireFile, unzip, openjdk }:

stdenv.mkDerivation rec {
  name = "sqldeveloper-17.2.0.188.1159";

  src = requireFile {
    name = "${name}-no-jre.zip";
    url = "http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/";
	/* Actual direct link (would it be allowed to give that link?): http://download.oracle.com/otn/java/sqldeveloper/sqldeveloper-17.2.0.188.1159-no-jre.zip */
    sha256 = "03960705fabc7b3fa98d55a31ee6a17f783b8c8b01462613c6b6a699e8cae4d5";
  };

  buildInputs = [ makeWrapper unzip ];

  buildCommand = ''
    mkdir -p $out/bin
    echo  >$out/bin/sqldeveloper '#! ${stdenv.shell}'
    echo >>$out/bin/sqldeveloper 'export JAVA_HOME=${openjdk}/lib/openjdk'
    echo >>$out/bin/sqldeveloper 'export JDK_HOME=$JAVA_HOME'
    echo >>$out/bin/sqldeveloper "cd $out/lib/${name}/sqldeveloper/bin"
    echo >>$out/bin/sqldeveloper '${stdenv.shell} sqldeveloper "$@"'
    chmod +x $out/bin/sqldeveloper

    mkdir -p $out/lib/
    cd $out
    unzip ${src}
    mv sqldeveloper $out/lib/${name}
  '';

  meta = with stdenv.lib; {
    description = "Oracle's Oracle DB GUI client";
    longDescription = ''
      Oracle SQL Developer is a free integrated development environment that
      simplifies the development and management of Oracle Database in both
      traditional and Cloud deployments. SQL Developer offers complete
      end-to-end development of your PL/SQL applications, a worksheet for
      running queries and scripts, a DBA console for managing the database,
      a reports interface, a complete data modeling solution, and a migration
      platform for moving your 3rd party databases to Oracle.
    '';
    homepage = http://www.oracle.com/technetwork/developer-tools/sql-developer/overview/;
    license = licenses.unfree;
    maintainers = [ maintainers.ardumont ];
    platforms = platforms.linux;
  };
}
