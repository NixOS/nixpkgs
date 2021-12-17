{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pylode";
  version = "2.12.0";
  format = "setuptools";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = pname;
    rev = version;
    sha256 = "sha256-X/YiJduAJNiceIrlCFwD2PFiMn3HVlzr9NzyDvYcql8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    falcon
    jinja2
    markdown
    python-dateutil
    rdflib
    requests
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "rdflib==6.0.0" "rdflib"
  '';

  # Path issues with the tests
  doCheck = false;

  pythonImportsCheck = [
    "pylode"
  ];

  meta = with lib; {
    description = "OWL ontology documentation tool using Python and templating, based on LODE";
    homepage = "https://github.com/RDFLib/pyLODE";
    # Next release will move to BSD3
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ koslambrou ];
  };
}
