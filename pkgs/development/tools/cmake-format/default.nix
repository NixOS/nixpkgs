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
  version = "0.6.9";

  src = fetchPypi {
    inherit version;
    pname = "cmake_format";
    sha256 = "082d7949gsk5v72ap7k4p3vgmc126a0bfm195xpi4lb6khpbzy5j";
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
