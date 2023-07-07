{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "jtesta";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WrED2cSoqR276iOma+pZq/Uu1vQWJmtJvsI73r8ivJA=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Tool for ssh server auditing";
    homepage = "https://github.com/jtesta/ssh-audit";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ tv SuperSandro2000 ];
  };
}
