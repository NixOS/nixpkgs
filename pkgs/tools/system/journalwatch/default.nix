{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, systemd, pytest }:

buildPythonPackage rec {
  pname = "journalwatch";
  version = "1.1.0";
  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "The-Compiler";
    repo = pname;
    rev = "v${version}";
    hash = "sha512-60+ewzOIox2wsQFXMAgD7XN+zvPA1ScPz6V4MB5taVDhqCxUTMVOxodf+4AMhxtNQloXZ3ye7/0bjh1NPDjxQg==";
  };

  # can be removed post 1.1.0
  postPatch = ''
    substituteInPlace test_journalwatch.py \
      --replace "U Thu Jan  1 00:00:00 1970 prio foo [1337]" "U Thu Jan  1 00:00:00 1970 pprio foo [1337]"
  '';


  doCheck = true;
  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  propagatedBuildInputs = [
    systemd
  ];


  meta = with lib; {
    description = "A tool to find error messages in the systemd journal";
    homepage = "https://github.com/The-Compiler/journalwatch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ florianjacob ];
  };
}
