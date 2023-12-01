{ lib
, bubblewrap
, cacert
, fetchFromGitLab
, git
, imagemagick
, openmw
, python3Packages
, rustPlatform
, tes3cmd
, tr-patcher
}:

let
  version = "2.6.2";

  src = fetchFromGitLab {
    owner = "portmod";
    repo = "Portmod";
    rev = "v${version}";
    hash = "sha256-ufr2guaPdCvI5JOicL/lTrT3t6UlaY1hEB2xbwzhw6A=";
  };

  portmod-rust = rustPlatform.buildRustPackage rec {
    inherit src version;
    pname = "portmod-rust";

    cargoHash = "sha256-sAjgGVVjgXaWbmN/eGEvatYjkHeFTZNX1GXFcJqs3GI=";

    nativeBuildInputs = [
      python3Packages.python
    ];

    doCheck = false;
  };

  bin-programs = [
    bubblewrap
    git
    python3Packages.virtualenv
    tr-patcher
    tes3cmd
    imagemagick
    openmw
  ];

in
python3Packages.buildPythonApplication rec {
  inherit src version;

  pname = "portmod";
  format = "pyproject";

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # build the rust library independantly
  prePatch = ''
    substituteInPlace setup.py \
      --replace "from setuptools_rust import Binding, RustExtension, Strip" "" \
      --replace "RustExtension(\"portmodlib.portmod\", binding=Binding.PyO3, strip=Strip.Debug)" ""

    substituteInPlace pyproject.toml \
      --replace '"setuptools-rust"' ""
  '';

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    setuptools-scm
    setuptools
    requests
    chardet
    colorama
    deprecated
    restrictedpython
    appdirs
    gitpython
    progressbar2
    python-sat
    redbaron
    patool
    packaging
    fasteners
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ] ++ bin-programs;

  preCheck = ''
    cp ${portmod-rust}/lib/libportmod.so portmodlib/portmod.so
    export HOME=$(mktemp -d)
  '';

  # some test require network access
  disabledTests = [
    "test_masters_esp"
    "test_logging"
    "test_execute_network_permissions"
    "test_execute_permissions_bleed"
    "test_git"
    "test_sync"
    "test_manifest"
    "test_add_repo"
    "test_init_prefix_interactive"
    "test_scan_sources"
    "test_unpack"
  ];

  # for some reason, installPhase doesn't copy the compiled binary
  postInstall = ''
    cp ${portmod-rust}/lib/libportmod.so $out/${python3Packages.python.sitePackages}/portmodlib/portmod.so

    makeWrapperArgs+=("--prefix" "GIT_SSL_CAINFO" ":" "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      "--prefix" "PATH" ":" "${lib.makeBinPath bin-programs }")
  '';

  meta = with lib; {
    description = "mod manager for openMW based on portage";
    homepage = "https://gitlab.com/portmod/portmod";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marius851000 ];
  };
}
