{ stdenv, fetchFromGitHub, python2Packages, writeText, writeScript
, coreutils, sqlite }:

let
  dbSql = writeText "create_pykms_db.sql" ''
    CREATE TABLE clients(
      clientMachineId TEXT,
      machineName     TEXT,
      applicationId   TEXT,
      skuId           TEXT,
      licenseStatus   TEXT,
      lastRequestTime INTEGER,
      kmsEpid         TEXT,
      requestCount    INTEGER
    );
  '';

  dbScript = writeScript "create_pykms_db.sh" (with stdenv.lib; ''
    #!${stdenv.shell} -eu

    db=$1

    ${getBin coreutils}/bin/install -d $(dirname $db)

    if [ ! -e $db ] ; then
      ${getBin sqlite}/bin/sqlite3 $db < ${dbSql}
    fi
  '');

in python2Packages.buildPythonApplication rec {
  name = "pykms-${version}";
  version = "20170719";

  src = fetchFromGitHub {
    owner  = "ThunderEX";
    repo   = "py-kms";
    rev    = "27355d88affd740330174a7c2bae9f50b9efce56";
    sha256 = "0cpywj73jmyijjc5hs3b00argjsdwpqzmhawbxkx3mc2l4sgzc88";
  };

  propagatedBuildInputs = with python2Packages; [ argparse pytz ];

  prePatch = ''
    siteDir=$out/${python2Packages.python.sitePackages}

    substituteInPlace kmsBase.py \
      --replace "'KmsDataBase.xml'" "'$siteDir/KmsDataBase.xml'"
  '';

  dontBuild = true;

  # there are no tests
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/doc/pykms} $siteDir

    mv * $siteDir
    for b in client server ; do
      chmod 0755 $siteDir/$b.py
      makeWrapper ${python2Packages.python.interpreter} $out/bin/$b.py \
        --add-flags $siteDir/$b.py
    done

    install -m755 ${dbScript} $out/bin/create_pykms_db.sh

    mv $siteDir/README.md $out/share/doc/pykms/

    ${python2Packages.python.interpreter} -m compileall $siteDir

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Windows KMS (Key Management Service) server written in Python";
    homepage    = https://github.com/ThunderEX/py-kms;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
