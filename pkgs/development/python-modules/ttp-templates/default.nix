{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
}:

buildPythonPackage rec {
  pname = "ttp-templates";
  version = "0.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = "ttp_templates";
    rev = "refs/tags/${version}";
    hash = "sha256-NlTTydGdjn+hwAKYEyINg/9k/EdnLq2gU9cnujpZQLM=";
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
    changelog = "https://github.com/dmulyalin/ttp_templates/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
