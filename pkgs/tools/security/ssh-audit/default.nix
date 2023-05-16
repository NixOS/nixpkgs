<<<<<<< HEAD
{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "3.0.0";
  format = "setuptools";
=======
{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "2.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jtesta";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    sha256 = "sha256-+v+DLZPDC5uffTIJPzMvY/nLoy7BGiAsTddjNZZhTpo=";
=======
    rev = "v${version}";
    sha256 = "sha256-WrED2cSoqR276iOma+pZq/Uu1vQWJmtJvsI73r8ivJA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Tool for ssh server auditing";
    homepage = "https://github.com/jtesta/ssh-audit";
<<<<<<< HEAD
    changelog = "https://github.com/jtesta/ssh-audit/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ tv SuperSandro2000 ];
  };
}
