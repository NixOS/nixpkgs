{ stdenv, makeWrapper, requireFile, unzip, openjdk }:

stdenv.mkDerivation rec {
  version = "17.4.0.355.2349";
  name = "sqldeveloper-${version}";

  src = requireFile rec {
    name = "sqldeveloper-${version}-no-jre.zip";
    url = "http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/";
    message = ''
      This Nix expression requires that ${name} already be part of the store. To
      obtain it you need to

      - navigate to ${url}
      - make sure that it says "Version ${version}" above the list of downloads
        - if it does not, click on the "Previous Version" link below the downloads
          and repeat until the version is correct. This is necessarry because as the
          time of this writing there exists no permanent link for the current version
          yet.
          Also consider updating this package yourself (you probably just need to
          change the `version` variable and update the sha256 to the one of the
          new file) or opening an issue at the nixpkgs repo.
      - accept the license agreement
      - download the file listed under "Other Platforms"
      - sign in or create an oracle account if neccessary

      and then add the file to the Nix store using either:

        nix-store --add-fixed sha256 ${name}

      or

        nix-prefetch-url --type sha256 file:///path/to/${name}
    '';
    # obtained by `sha256sum sqldeveloper-${version}-no-jre.zip`
    sha256 = "70add9b5c998583416e3d127aeb63dde8e3d0489036982026b930c85496c7850";
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
