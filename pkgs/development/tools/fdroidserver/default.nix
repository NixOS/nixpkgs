{ lib
, fetchFromGitLab
, apksigner
, buildPythonApplication
, python3
, pythonRelaxDepsHook
, installShellFiles
, androguard
, babel
, clint
, defusedxml
, gitpython
, libcloud
, paramiko
, pillow
, pyasn1
, pyasn1-modules
, python-vagrant
, pyyaml
, qrcode
, requests
, ruamel-yaml
, sdkmanager
, setuptools
, yamllint
}:

buildPythonApplication rec {
  pname = "fdroidserver";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = "refs/tags/${version}";
    hash = "sha256-fNgm0iw9TbcEISWu33tSi9THOr51qCbKNxoWeJlAex0=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "pyasn1"
    "pyasn1-modules"
  ];

  postPatch = ''
    substituteInPlace fdroidserver/common.py \
      --replace "FDROID_PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))" "FDROID_PATH = '$out/bin'"
  '';

  preConfigure = ''
    ${python3.pythonOnBuildForHost.interpreter} setup.py compile_catalog
  '';

  postInstall = ''
    patchShebangs gradlew-fdroid
    install -m 0755 gradlew-fdroid $out/bin
    installShellCompletion --cmd fdroid \
      --bash completion/bash-completion
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
    installShellFiles
  ];

  buildInputs = [
    babel
  ];

  dependencies = [
    androguard
    clint
    defusedxml
    gitpython
    libcloud
    paramiko
    pillow
    pyasn1
    pyasn1-modules
    python-vagrant
    pyyaml
    qrcode
    requests
    ruamel-yaml
    sdkmanager
    yamllint
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ apksigner ]}"
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "fdroidserver"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/fdroid/fdroidserver";
    changelog = "https://gitlab.com/fdroid/fdroidserver/-/blob/${version}/CHANGELOG.md";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ linsui jugendhacker ];
    mainProgram = "fdroid";
  };
}
