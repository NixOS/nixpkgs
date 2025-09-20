{
  lib,
  buildPythonApplication,
  fetchPypi,
  autopep8,
  flake8,
  jinja2,
  pylint,
  pyyaml,
  six,
}:

buildPythonApplication rec {
  pname = "cmake-format";
  version = "0.6.13";
  # The source distribution does not build because of missing files.
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    python = "py3";
    pname = "cmakelang";
    sha256 = "0kmggnfbv6bba75l3zfzqwk0swi90brjka307m2kcz2w35kr8jvn";
  };

  propagatedBuildInputs = [
    autopep8
    flake8
    jinja2
    pylint
    pyyaml
    six
  ];

  doCheck = false;

  meta = {
    description = "Source code formatter for cmake listfiles";
    homepage = "https://github.com/cheshirekow/cmake_format";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.tobim ];
    mainProgram = "cmake-format";
    platforms = lib.platforms.all;
  };
}
