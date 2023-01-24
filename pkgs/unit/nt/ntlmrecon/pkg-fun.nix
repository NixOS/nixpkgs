{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ntlmrecon";
  version = "0.4";
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pwnfoo";
    repo = "NTLMRecon";
    rev = "v-${version}";
    sha256 = "0rrx49li2l9xlcax84qxjf60nbzp3fgq77c36yqmsp0pc9i89ah6";
  };

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    iptools
    requests
    termcolor
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "ntlmrecon" ];

  meta = with lib; {
    description = "Information enumerator for NTLM authentication enabled web endpoints";
    homepage = "https://github.com/pwnfoo/NTLMRecon";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
