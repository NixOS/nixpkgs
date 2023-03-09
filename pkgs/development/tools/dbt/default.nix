{ lib
, fetchFromGitHub
, python3Packages
, rustPlatform
}:

let
  mashumaro = python3Packages.buildPythonPackage rec {
    pname = "mashumaro";
    version = "3.3.1"; # dbt wants a specific version

    disabled = python3Packages.pythonOlder "3.6";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-mX7QpM5klnuW/2X1yna45eRZpOx6ag9zYloGcASoAck=";
    };

    propagatedBuildInputs = with python3Packages; [
      typing-extensions
      msgpack
      pyyaml
      tomli
      tomli-w
      pydantic
      orjson
      marshmallow
      cattrs
    ];

    pythonImportsCheck = [ "mashumaro" ];
  };

  logbook = python3Packages.buildPythonPackage rec {
    pname = "Logbook";
    version = "1.5.3";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-ZvRUraD1bq5DBm9gSiIrCYk/mMGtwY3xaXEHYbjzL+g=";
    };

    # Wants to run some kind of connection to something
    doCheck = false;

    pythonImportsCheck = [ "logbook" ];
  };

  minimal-snowplow-tracker = python3Packages.buildPythonPackage rec {
    pname = "minimal-snowplow-tracker";
    version = "0.0.2";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-rKv3Vy2w5/XL9pg9SV7vVAgfcb45IzDrOq25zLOdqqQ=";
    };

    propagatedBuildInputs = with python3Packages; [
      six
      requests
    ];

    pythonImportsCheck = [ "snowplow_tracker" ];
  };

  dbt-extractor = python3Packages.buildPythonPackage rec {
    pname = "dbt_extractor";
    version = "0.4.1";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-dbHGZWmewPH/zhuj13b3386AIVbyLnCnucjwtNfoD0I=";
    };

    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${pname}-${version}";
      sha256 = "sha256-COuFqMxgzPEldfdP9WTZjUq504bLF+qopZYfDQeWLzM=";
    };

    nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

    # No such file or directory: 'setup.py'
    doCheck = false;

    pythonImportsCheck = [ "dbt_extractor" ];
  };

  betterproto = python3Packages.buildPythonPackage rec {
    pname = "betterproto";
    version = "1.2.5";  # dbt wants a specific version

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-dKOrNGRgVPZ00jbRIpuoGC3C6uhv6ySbhZDvSWzpgD0=";
    };

    nativeBuildInputs = with python3Packages; [
      black
    ];

    propagatedBuildInputs = with python3Packages; [
      stringcase
      grpclib
      jinja2
      protobuf
    ];

    pythonImportsCheck = [ "betterproto" ];
  };

  hologram = python3Packages.buildPythonPackage rec {
    pname = "hologram";
    version = "0.0.15";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-ebPQTfhNWp0JwuZp7FvMULFxPsefRoPP3qhVg7QeRvA=";
    };

    propagatedBuildInputs = with python3Packages; [
      jsonschema_3
      python-dateutil
    ];

    pythonImportsCheck = [ "hologram" ];
  };

in
python3Packages.buildPythonApplication rec {
  pname = "dbt-core";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-fE0lyHD889wcHmtUKcxNs7WB94PecW3ub7f2obVyNio=";
  };

  propagatedBuildInputs = with python3Packages; [
    cffi
    mashumaro
    jinja2
    sqlparse
    werkzeug
    agate
    networkx
    logbook
    minimal-snowplow-tracker
    dbt-extractor
    pathspec
    click
    packaging
    colorama
    betterproto
    hologram
  ];

  postUnpack = ''
    # Find the absolute source root to link correctly to the previous root
    prevRoot=$(realpath $sourceRoot)

    # Update the source root
    sourceRoot="$sourceRoot/core"
  '';

  # ModuleNotFoundError: No module named 'test.test'
  # Probably picking up the wrong directory for testing
  doCheck = false;

  meta = with lib; {
    description = "Enables data analysts and engineers to transform their data using the same practices that software engineers use to build applications.";
    homepage = "https://getdbt.com/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mausch ];
  };
}
