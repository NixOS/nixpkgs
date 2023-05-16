{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ntlmrecon";
  version = "0.4";
<<<<<<< HEAD
  format = "setuptools";
=======
  disabled = python3.pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pwnfoo";
    repo = "NTLMRecon";
<<<<<<< HEAD
    rev = "refs/tags/v-${version}";
=======
    rev = "v-${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

  pythonImportsCheck = [
    "ntlmrecon"
  ];
=======
  pythonImportsCheck = [ "ntlmrecon" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Information enumerator for NTLM authentication enabled web endpoints";
    homepage = "https://github.com/pwnfoo/NTLMRecon";
<<<<<<< HEAD
    changelog = "https://github.com/pwnfoo/NTLMRecon/releases/tag/v-${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
