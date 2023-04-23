{ lib
, fetchFromGitLab
, python
, apksigner
}:

python.pkgs.buildPythonApplication rec {
  pname = "fdroidserver";
  version = "2.1.1";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = version;
    sha256 = "0qg4vxjcgm05dqk3kyj8lry9wh5bxy0qwz70fiyxb5bi1kwai9ss";
  };

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

  makeWrapperArgs = [ "--prefix" "PATH" ":" "${lib.makeBinPath [ apksigner ]}" ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "fdroidserver" ];

  meta = with lib; {
    homepage = "https://f-droid.org";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = licenses.agpl3;
    maintainers = with maintainers; [ obfusk ];
  };

}
