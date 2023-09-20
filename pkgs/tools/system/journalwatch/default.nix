{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, systemd, pytest }:

buildPythonPackage rec {
  pname = "journalwatch";
  version = "1.1.0";
  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "The-Compiler";
    repo = pname;
    rev = "v${version}";
    sha512 = "11g2f1w9lfqw6zxxyg7qrqpb914s6w71j0gnpw7qr7cak2l5jlf2l39dlg30y55rw7jgmf0yg77wwzd0c430mq1n6q1v8w86g1rwkzb";
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
    description = "journalwatch is a tool to find error messages in the systemd journal.";
    homepage = "https://github.com/The-Compiler/journalwatch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ florianjacob ];
  };
}
