{ stdenv, pythonPackages, runCommand, curl }:

with stdenv.lib;
with pythonPackages;

let
  version = "1.3.0";
in buildPythonApplication rec {
  inherit version;
  pname = "pantsbuild.pants";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18fcf9047l9k006wz21g525p1w5avyjabmabh0giyz22xnm8g5gp";
  };

  prePatch = ''
    sed -E -i "s/'([[:alnum:].-]+)[=><][[:digit:]=><.,]*'/'\\1'/g" setup.py
  '';

  # Unnecessary, and causes some really weird behavior around .class files, which
  # this package bundles. See https://github.com/NixOS/nixpkgs/issues/22520.
  dontStrip = true;

  propagatedBuildInputs = [
    twitter-common-collections setproctitle setuptools six ansicolors
    packaging pathspec scandir twitter-common-dirutil psutil requests
    pystache pex docutils markdown pygments twitter-common-confluence
    fasteners coverage pywatchman futures cffi
  ];

  meta = {
    description = "A build system for software projects in a variety of languages";
    homepage    = "http://www.pantsbuild.org/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.unix;
  };
}
