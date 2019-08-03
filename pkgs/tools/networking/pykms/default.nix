{ stdenv, fetchFromGitHub, python3Packages, writeText, writeScript
, coreutils, sqlite }:

with python3Packages;

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

in buildPythonApplication rec {
  name = "pykms-${version}";
  version = "20180208";

  src = fetchFromGitHub {
    owner  = "ThunderEX";
    repo   = "py-kms";
    rev    = "a1666a0ee5b404569a234afd05b164accc9a8845";
    sha256 = "17yj5n8byxp09l5zkap73hpphjy35px84wy68ps824w8l0l8kcd4";
  };

  propagatedBuildInputs = [ pytz ];

  prePatch = ''
    siteDir=$out/${python.sitePackages}

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
      makeWrapper ${python.interpreter} $out/bin/$b.py \
        --argv0 $b \
        --add-flags $siteDir/$b.py
    done

    install -m755 ${dbScript} $out/bin/create_pykms_db.sh

    mv $siteDir/README.md $out/share/doc/pykms/

    ${python.interpreter} -m compileall $siteDir

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Windows KMS (Key Management Service) server written in Python";
    homepage    = https://github.com/ThunderEX/py-kms;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
