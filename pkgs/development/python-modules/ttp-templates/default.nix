{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
}:

buildPythonPackage rec {
  pname = "ttp-templates";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = "ttp_templates";
    rev = "refs/tags/${version}";
    hash = "sha256-35Ej76E9qy5EY41Jt2GDCldyXq7IkdqKxVFrBOJh9nE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    # Drop circular dependency on ttp
    sed -i '/ttp =/d' pyproject.toml
  '';

  # Circular dependency on ttp
  doCheck = false;

  meta = with lib; {
    description = "Template Text Parser Templates collections";
    homepage = "https://github.com/dmulyalin/ttp_templates";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
