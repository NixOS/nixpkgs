{ lib, stdenv, makeWrapper, requireFile, unzip, jdk }:

let
  version = "22.4.0.342.1212";
  fileVersion = "1032835-01";
in
  stdenv.mkDerivation {

  inherit version;
  pname = "sqlcl";

  src = requireFile rec {
    url = "https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/download/";
    name = "V${fileVersion}.zip";
    message = ''
      This Nix expression requires that ${name} already be part of the store. To
      obtain it you need to

      - navigate to ${url}
      - make sure that it says "Version ${version}" above the list of downloads
        - if it does not, click on the "Previous Version" link below the
          download and repeat until the version is correct. This is necessary
          because as the time of this writing there exists no permanent link
          for the current version yet.
          Also consider updating this package yourself (you probably just need
          to change the `version` variable and update the sha256 to the one of
          the new file) or opening an issue at the nixpkgs repo.
      - click "Download"
      - sign in or create an oracle account if neccessary
      - on the next page, click the "${name}" link

      and then add the file to the Nix store using either:

        nix-store --add-fixed sha256 ${name}

      or

        nix-prefetch-url --type sha256 file:///path/to/${name}
    '';
    sha256 = "0i4xsj502s465fgmlcqn80r8rqzr11mv74x9fzrlbqmkkh5c782k";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  unpackCmd = "unzip $curSrc";

  installPhase = ''
    mkdir -p $out/libexec
    mv * $out/libexec/

    makeWrapper $out/libexec/bin/sql $out/bin/sqlcl \
      --set JAVA_HOME ${jdk.home} \
      --chdir "$out/libexec/bin"
  '';

  meta = with lib; {
    description = "Oracle's Oracle DB CLI client";
    longDescription = ''
      Oracle SQL Developer Command Line (SQLcl) is a free command line
      interface for Oracle Database. It allows you to interactively or batch
      execute SQL and PL/SQL. SQLcl provides in-line editing, statement
      completion, and command recall for a feature-rich experience, all while
      also supporting your previously written SQL*Plus scripts.
    '';
    homepage = "https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ misterio77 ];
  };
}
