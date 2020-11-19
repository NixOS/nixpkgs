{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "jtesta";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h739r5nv5zkmjyyjwkw8r6d4avddjjxsamc5rffwfxi1kjavpxm";
  };

  checkInputs = with python3Packages; [
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
