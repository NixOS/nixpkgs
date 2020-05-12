{ stdenv, runtimeShell, fetchFromGitHub, python3, writeText, writeScript
, coreutils, sqlite }:

with python3.pkgs;

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
    #!${runtimeShell}

    set -eEuo pipefail

    db=$1

    if [ ! -e $db ] ; then
      ${getBin sqlite}/bin/sqlite3 $db < ${dbSql}
    fi
  '');

in buildPythonApplication rec {
  pname = "pykms";
  version = "20190611";

  src = fetchFromGitHub {
    owner  = "SystemRage";
    repo   = "py-kms";
    rev    = "dead208b1593655377fe8bc0d74cc4bead617103";
    sha256 = "065qpkfqrahsam1rb43vnasmzrangan5z1pr3p6s0sqjz5l2jydp";
  };

  sourceRoot = "source/py-kms";

  propagatedBuildInputs = [ systemd pytz tzlocal ];

  # Fix https://github.com/SystemRage/py-kms/issues/64 :
  patches = [ ./log-to-current-directory-by-default.patch ];

  postPatch = ''
    siteDir=$out/${python3.sitePackages}

    substituteInPlace pykms_DB2Dict.py \
      --replace "'KmsDataBase.xml'" "'$siteDir/KmsDataBase.xml'"
  '';

  format = "other";

  # there are no tests
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $siteDir

    mv * $siteDir
    for b in Client Server ; do
      makeWrapper ${python.interpreter} $out/bin/''${b,,} \
        --argv0 ''${b,,} \
        --add-flags $siteDir/pykms_$b.py \
        --prefix PYTHONPATH : "$(toPythonPath ${systemd})"
    done

    install -Dm755 ${dbScript} $out/libexec/create_pykms_db.sh

    install -Dm644 ../README.md -t $out/share/doc/pykms

    ${python.interpreter} -m compileall $siteDir

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Windows KMS (Key Management Service) server written in Python";
    homepage    = "https://github.com/SystemRage/py-kms";
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
