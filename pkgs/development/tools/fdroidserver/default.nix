{ lib
, fetchFromGitLab
, python
, apksigner
}:

python.pkgs.buildPythonApplication rec {
  pname = "fdroidserver";
  version = "2.2.0";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = version;
    sha256 = "16q2bamm2jkdp2zd6iv2gjrk9fcg15vi9w6hfw8ckrnlfaa3z3l2";
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
