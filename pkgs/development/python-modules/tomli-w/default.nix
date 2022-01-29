{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, flit-core
}:

buildPythonPackage rec {
  pname = "tomli-w";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "sha256-wZSC5uOi1JUeKXIli1I8/Vo0wGsv9Q1I84dAMQQP95w=";
  };

  nativeBuildInputs = [ flit-core ];

  pythonImportsCheck = [ "tomli_w" ];

  meta = with lib; {
    description = "A write-only counterpart to Tomli, which is a read-only TOML parser";
    homepage = "https://github.com/hukkin/tomli-w";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
