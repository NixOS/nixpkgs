{ lib
, fetchFromGitHub
, perl
, python3
, sqlite
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fabs";
  version = "1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openafs-contrib";
    repo = "fabs";
    rev = "v${version}";
    hash = "sha256-ejAcCwrOWGX0zsMw224f9GTWlozNYC0gU6LdTk0XqH0=";
  };

  nativeBuildInputs = [
    perl
  ];

  propagatedBuildInputs = with python3.pkgs; [
    alembic
    python-dateutil
    pyyaml
    setuptools
    sqlalchemy
  ];

  outputs = [ "out" "man" ];

  preBuild = ''
    export PREFIX=$out
  '';

  LOCALSTATEDIR = "/var";
  LOCKDIR = "/run/lock/fabs";

  preInstall = ''
    mkdir -p "$out/etc"
    cp -t "$out/etc" -r etc/fabs
  '';

  # remove once sqlalchemy backend no longer uses deprecated methods
  SQLALCHEMY_SILENCE_UBER_WARNING = 1;

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    sqlite
  ];

  meta = with lib; {
    outputsToInstall = [ "out" "man" ];
    mainProgram = "fabsys";
    description = "Flexible AFS Backup System for the OpenAFS distributed file system";
    homepage = "https://github.com/openafs-contrib/fabs";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ spacefrogg ];
    broken = lib.versionAtLeast python3.pkgs.sqlalchemy.version "2.0";
    badPlatforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
