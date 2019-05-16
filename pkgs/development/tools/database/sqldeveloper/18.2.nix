{ stdenv, makeDesktopItem, makeWrapper, requireFile, unzip, jdk }:

let
  version = "18.2.0.183.1748";

  desktopItem = makeDesktopItem {
    name = "sqldeveloper";
    exec = "sqldeveloper";
    icon = "sqldeveloper";
    desktopName = "Oracle SQL Developer 18";
    genericName = "Oracle SQL Developer 18";
    comment = "Oracle's Oracle DB GUI client";
    categories = "Application;Development;";
  };
in
  stdenv.mkDerivation rec {

  inherit version;
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
    sha256 = "0clz2w4ghqczy9sz6j4qqygk20whdwkca192pd3v0dw09875as0k";
  };

  buildInputs = [ makeWrapper unzip ];

  unpackCmd = "unzip $curSrc";

  installPhase = ''
    mkdir -p $out/libexec $out/share/{applications,pixmaps}
    mv * $out/libexec/

    mv $out/libexec/icon.png $out/share/pixmaps/sqldeveloper.png
    cp ${desktopItem}/share/applications/* $out/share/applications

    makeWrapper $out/libexec/sqldeveloper/bin/sqldeveloper $out/bin/sqldeveloper \
      --set JAVA_HOME ${jdk.home} \
      --run "cd $out/libexec/sqldeveloper/bin"
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
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ardumont flokli ma27 ];
  };
}
