{
  lib,
  fetchFromGitLab,
  fetchPypi,
  apksigner,
  appdirs,
  buildPythonApplication,
  python3,
  installShellFiles,
  androguard,
  babel,
  clint,
  defusedxml,
  gitpython,
  libcloud,
  mwclient,
  oscrypto,
  paramiko,
  pillow,
  pyasn1,
  pyasn1-modules,
  python-vagrant,
  pyyaml,
  qrcode,
  requests,
  ruamel-yaml,
  sdkmanager,
  yamllint,
}:

let
  version = "2.3a1";
in
buildPythonApplication {
  pname = "fdroidserver";
  inherit version;

  pyproject = true;

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = "2.3a1";
    hash = "sha256-K6P5yGx2ZXHJZ/VyHTbQAObsvcfnOatrpwiW+ixLTuA=";
  };

  pythonRelaxDeps = [
    "androguard"
    "pyasn1"
    "pyasn1-modules"
  ];

  postPatch = ''
    substituteInPlace fdroidserver/common.py \
      --replace-fail "FDROID_PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))" "FDROID_PATH = '$out/bin'"
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

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ babel ];

  propagatedBuildInputs = [
    androguard
    appdirs
    clint
    defusedxml
    gitpython
    libcloud
    mwclient
    oscrypto
    paramiko
    pillow
    pyasn1
    pyasn1-modules
    python-vagrant
    pyyaml
    qrcode
    requests
    (ruamel-yaml.overrideAttrs (old: {
      src = fetchPypi {
        pname = "ruamel.yaml";
        version = "0.17.21";
        hash = "sha256-i3zml6LyEnUqNcGsQURx3BbEJMlXO+SSa1b/P10jt68=";
      };
    }))
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

  pythonImportsCheck = [ "fdroidserver" ];

  meta = {
    homepage = "https://gitlab.com/fdroid/fdroidserver";
    changelog = "https://gitlab.com/fdroid/fdroidserver/-/blob/${version}/CHANGELOG.md";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      linsui
      jugendhacker
    ];
    mainProgram = "fdroid";
  };
}
