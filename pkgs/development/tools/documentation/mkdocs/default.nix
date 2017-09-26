{ lib, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  version = "0.16.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z9n0dnidnvm511pdzf73grmr4xn59znkfalq8x9gw5v7lqwa2mc";
  };

  propagatedBuildInputs = [
    tornado
    livereload
    click
    pyyaml
    markdown
    jinja2
  ];

  meta = {
    homepage = http://mkdocs.org/;
    description = "Project documentation with Markdown";
    license = lib.licenses.bsd2;
  };
}
