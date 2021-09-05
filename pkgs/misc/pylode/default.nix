{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "pyLODE";
  version = "2.8.6";

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = pname;
    rev = version;
    sha256 = "0zbk5lj9vlg32rmvw1himlw63kxd7sim7nzglrjs5zm6vpi4x5ch";
  };

  propagatedBuildInputs = with python3Packages; [
    python-dateutil
    falcon
    gunicorn
    isodate
    jinja2
    markdown
    rdflib
    rdflib-jsonld
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
