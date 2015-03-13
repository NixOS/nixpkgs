{ stdenv, makeWrapper, requireFile, unzip, oraclejdk7, bash}:

stdenv.mkDerivation rec {
  version = "4.0.3.16.84";
  name = "sqldeveloper-${version}";

  src = requireFile {
    name = "${name}-no-jre.zip";
    url = http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html;
    sha256 = "1qbqjkfda7xry716da2hdbbazks96rgyslrw1lw0azmqdp1mir7g";
  };

  buildInputs = [ makeWrapper unzip ];

  buildCommand = ''
    mkdir -p $out/bin
    # patch to be able to install a sqldeveloper wrapper script compliant with nix's bin folder once installed
    echo -e '#!${bash}/bin/bash\ncd "`dirname $0`"/../sqldeveloper/bin && ${bash}/bin/bash sqldeveloper $*' >> $out/bin/sqldeveloper

    cd $out
    unzip ${src}
    cp -r sqldeveloper/* $out/
    # Activate the needed shell script
    rm $out/sqldeveloper.sh
    chmod +x $out/bin/sqldeveloper
    chmod +x $out/sqldeveloper/bin/sqldeveloper

    wrapProgram $out/bin/sqldeveloper \
      --set JAVA_HOME "${oraclejdk7}"
  '';

  meta = with stdenv.lib; {
    description = "Oracle's Oracle DB GUI client.";
    longDescription = ''
      Oracle SQL Developer is a free integrated development environment that
      simplifies the development and management of Oracle Database in both
      traditional and Cloud deployments. SQL Developer offers complete
      end-to-end development of your PL/SQL applications, a worksheet for
      running queries and scripts, a DBA console for managing the database,
      a reports interface, a complete data modeling solution, and a migration
      platform for moving your 3rd party databases to Oracle.
    '';
    homepage = http://www.oracle.com/technetwork/developer-tools/sql-developer/overview/index.html;
    license = licenses.unfree;
    maintainers = [ maintainers.ardumont ];
    platforms = platforms.linux;
  };
}
