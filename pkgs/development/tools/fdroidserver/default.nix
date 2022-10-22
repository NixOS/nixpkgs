{ fetchFromGitLab
, python
, lib
, apksigner
}:

python.pkgs.buildPythonApplication rec {
  version = "2.1";
  pname = "fdroidserver";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = version;
    sha256 = "0xmmjj7f05p4q8xbbkxqns2vvk2rsvb9n43vjdv0wbydmgpa34k7";
  };

  postPatch = ''
    substituteInPlace fdroidserver/common.py --replace "FDROID_PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))" "FDROID_PATH = '$out/bin'"
  '';

  preConfigure = ''
    ${python.interpreter} setup.py compile_catalog
  '';
  postInstall = ''
    patchShebangs gradlew-fdroid
    install -m 0755 gradlew-fdroid $out/bin
  '';

  buildInputs = [ python.pkgs.babel ];

  propagatedBuildInputs = with python.pkgs; [
    androguard
    clint
    defusedxml
    GitPython
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
    maintainers = [ lib.maintainers.obfusk ];
  };

}
