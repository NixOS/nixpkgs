{ lib
, fetchFromGitLab
, python
, apksigner
}:

python.pkgs.buildPythonApplication rec {
  pname = "fdroidserver";
  version = "2.2.1";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = "refs/tags/${version}";
    sha256 = "sha256-+Y1YTgELsX834WIrhx/NX34yLMHdkKM+YUNvnHPiC/s=";
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
    ${python.pythonForBuild.interpreter} setup.py compile_catalog
  '';

  postInstall = ''
    patchShebangs gradlew-fdroid
    install -m 0755 gradlew-fdroid $out/bin
  '';

  nativeBuildInputs = with python.pkgs; [
    pythonRelaxDepsHook
  ];

  buildInputs = with python.pkgs; [
    babel
  ];

  propagatedBuildInputs = with python.pkgs; [
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
    ruamel-yaml
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
    homepage = "https://github.com/f-droid/fdroidserver";
    changelog = "https://github.com/f-droid/fdroidserver/blob/${version}/CHANGELOG.md";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ obfusk ];
  };

}
