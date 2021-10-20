{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "pyLODE";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = pname;
    rev = version;
    sha256 = "sha256-X/YiJduAJNiceIrlCFwD2PFiMn3HVlzr9NzyDvYcql8=";
  };

  propagatedBuildInputs = with python3Packages; [
    python-dateutil
    falcon
    gunicorn
    isodate
    jinja2
    markdown
    rdflib
    requests
    six
    beautifulsoup4
  ];

  meta = with lib; {
    description = "An OWL ontology documentation tool using Python and templating, based on LODE";
    homepage = "https://github.com/RDFLib/pyLODE";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ koslambrou ];
  };
}
