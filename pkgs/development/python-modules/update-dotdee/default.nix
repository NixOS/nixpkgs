{ lib, buildPythonPackage, fetchFromGitHub, executor, naturalsort }:

buildPythonPackage rec {
  pname = "update-dotdee";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-update-dotdee";
    rev = version;
    sha256 = "1h3m593nwzx6vwa24k0wizb7la49yhqxwn73ipclxgxxi4dfdj01";
  };

  propagatedBuildInputs = [ executor naturalsort ];

  meta = with lib; {
    description = "Generic modularized configuration file manager";
    homepage = "https://github.com/xolox/python-update-dotdee";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
