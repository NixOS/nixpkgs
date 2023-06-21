{ lib, stdenvNoCC, requireFile, unzip, coreutils, perl, xorg, findutils }:

let
  requireFileMessage = filename: ''
    A valid Oracle Account is required to download Oracle Software from OTN.

    Download link: https://download.oracle.com/otn/linux/oracle19c/190000/${filename}

    Once the file is downloaded, rename it to ${filename} and then
    add it to the Nix store with the following command:
    nix-prefetch-url file:///path/to/${filename}
  '';

  filename = "LINUX.X64_193000_db_home.zip";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "oracle";
  version = "19c";

  src = requireFile {
    name = filename;
    sha256 = "1n5878ikaciz4gkg52x2f2cwshmcqn37yv9vxl9s6g8kaz3jk0xs";
    message = requireFileMessage filename;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip coreutils ];

  buildInputs = [ ];

  configurePhase = ''
    runHook preConfigure

    substituteInPlace ./runInstaller --replace "/usr/bin/dirname" "dirname"
    substituteInPlace ./runInstaller --replace "/bin/uname" "uname"
    substituteInPlace ./runInstaller --replace "\''${ORACLE_HOME}/perl/bin/perl" "${perl}/bin/perl"
    substituteInPlace ./bin/commonSetup.sh --replace "/bin/uname" "uname"
    substituteInPlace ./bin/commonSetup.sh --replace "/usr/bin/whoami" "whoami"
    substituteInPlace ./bin/commonSetup.sh --replace "/usr/bin/xdpyinfo" "${xorg.xdpyinfo}/bin/xdpyinfo"
    substituteInPlace ./bin/commonSetup.sh --replace "\''${ORACLE_HOME}/perl/bin/perl" "${perl}/bin/perl"
    substituteInPlace ./bin/commonSetup.sh --replace "/bin/find" "${findutils}/bin/find"
    substituteInPlace ./bin/commonSetup.sh --replace "EXEC_PERM=\"false\"" "EXEC_PERM=\"true\""

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    export ORACLE_BASE=$out/opt/oracle_base
    export ORACLE_HOME=$ORACLE_BASE/oracle_home

    ./runInstaller -ignorePrereq -waitforcompletion              \
    oracle.install.option=INSTALL_DB_SWONLY                      \
    SELECTED_LANGUAGES=en                                        \
    oracle.install.db.InstallEdition=EE                          \
    oracle.install.db.OSDBA_GROUP=dba                            \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                      \
    oracle.install.db.OSDGDBA_GROUP=dba                          \
    oracle.install.db.OSKMDBA_GROUP=dba                          \
    oracle.install.db.OSRACDBA_GROUP=dba                         \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                   \
    DECLINE_SECURITY_UPDATES=true

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.oracle.com/be/database/";
    description = "A proprietary multi-model database management system produced and marketed by Oracle Corporation";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.unix;
  };
})
