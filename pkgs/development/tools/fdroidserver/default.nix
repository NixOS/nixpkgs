{ docker
, fetchFromGitLab
, python
, lib }:

python.pkgs.buildPythonApplication rec {
  version = "2.0.3";
  pname = "fdroidserver";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = version;
    sha256 = "1z9d56fmc6lnsgmapgl80690wfin5adj8m8zzms6gcf3vzkgimgy";
  };

  patchPhase = ''
    substituteInPlace fdroidserver/common.py --replace "FDROID_PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))" "FDROID_PATH = '$out/bin'"
  '';

  preConfigure = ''
    ${python.interpreter} setup.py compile_catalog
  '';
  postInstall = ''
    patchShebangs gradlew-fdroid
    install -m 0755 gradlew-fdroid $out/bin
  '';

  buildInputs = [ python.pkgs.Babel ];

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
    ruamel_yaml
    yamllint
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://f-droid.org";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = licenses.agpl3;
    maintainers = [ lib.maintainers.obfusk ];
  };

}
