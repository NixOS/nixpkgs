{ buildPythonPackage
, fetchFromGitHub
, lib
, poetry-core
, termcolor
}:

buildPythonPackage rec {
  pname = "yaspin";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pavdmyt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vhh4mp706kz5fba8nvr9jm51jsd32xj97m3law6ixw3lj91sh1a";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ termcolor ];

  pythonImportsCheck = [ "yaspin" ];

  meta = with lib; {
    description = "Yet Another Terminal Spinner";
    homepage = "https://github.com/pavdmyt/yaspin";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
