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
  version = "0.6.8";

  src = fetchPypi {
    inherit version;
    pname = "cmake_format";
    sha256 = "0zpx7g5j8wv52zj0s7bk7cj5v82icn4il0jfydc1cmg4p5krf5iy";
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
