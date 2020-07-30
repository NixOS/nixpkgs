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
  version = "0.6.11";

  src = fetchPypi {
    inherit version;
    pname = "cmake_format";
    sha256 = "1wvmv8242xjkxgr266dkn4vrn5wm94fwn333pn7sxm5warhhwgda";
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
