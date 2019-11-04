{ lib
, buildPythonApplication
, fetchPypi
, autopep8
, flake8
, jinja2
, pylint
, pyyaml
}:

buildPythonApplication rec {
  pname = "cmake-format";
  version = "0.6.0";

  src = fetchPypi {
    inherit version;
    pname = "cmake_format";
    sha256 = "0sip832bxsvnm7fhqhx49d53g2s7swdk3fhyhlglm2shgj89b5zw";
  };

  propagatedBuildInputs = [ autopep8 flake8 jinja2 pylint pyyaml ];

  doCheck = false;

  meta = with lib; {
    description = "Source code formatter for cmake listfiles";
    homepage = "https://github.com/cheshirekow/cmake_format";
    license = licenses.gpl3;
    maintainers = [ maintainers.tobim ];
    platforms = platforms.all;
  };
}
