{ lib
, fetchFromGitLab
, fetchPypi
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
, mwclient
, paramiko
, pillow
, pyasn1
, pyasn1-modules
, python-vagrant
, pyyaml
, qrcode
, requests
, ruamel-yaml
, yamllint
}:

buildPythonApplication rec {
  pname = "fdroidserver";
  version = "unstable-2023-10-23";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = "f4b10cf83935432d19948dac669964384bef0728";
    hash = "sha256-GmR6Td5pScwEKK9W6m26xQV4XxBdZ7frN2UvwUGY4Dw=";
  };

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

  propagatedBuildInputs = [
    androguard
    clint
    defusedxml
    gitpython
    libcloud
    mwclient
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
