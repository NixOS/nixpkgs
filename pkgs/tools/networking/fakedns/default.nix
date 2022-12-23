{ python3, fetchFromGitHub, lib }:

python3.pkgs.buildPythonApplication {
  pname = "fakedns";
  version = "2022-08-14";

  src = fetchFromGitHub {
    owner = "wahlflo";
    repo = "fakedns";
    rev = "11397c3e5180f30de184fba1dbfe9fc8ea85fadd";
    sha256 = "sha256-ZGNZ8pa9loSTDqrx3ra7sRfsDKzJ1Z2UDlsg+qGq9xo=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    cli-formatter
    dns-messages
  ];

  pythonImportsCheck = [ "fakedns" ];

  meta = {
    description = "A fake DNS server for malware analysis";
    homepage = "https://github.com/wahlflo/fakedns";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.symphorien ];
  };
}
