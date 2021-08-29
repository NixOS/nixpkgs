{ lib, buildPythonPackage, fetchFromGitHub, executor, naturalsort }:

buildPythonPackage rec {
  pname = "update-dotdee";
  version = "6.0";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-update-dotdee";
    rev = version;
    sha256 = "sha256-2k7FdgWM0ESHQb2za87yhXGaR/rbMYLVcv10QexUH1A=";
  };

  propagatedBuildInputs = [ executor naturalsort ];

  meta = with lib; {
    description = "Generic modularized configuration file manager";
    homepage = "https://github.com/xolox/python-update-dotdee";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
