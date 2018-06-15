{ stdenv, pythonPackages, runCommand, curl }:

with stdenv.lib;
with pythonPackages;

let
  version = "1.6.0";
in buildPythonApplication rec {
  inherit version;
  pname = "pantsbuild.pants";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ahvcj33xribypgyh515mb3ack1djr0cq27nlyk0qhwgwv6acfnj";
  };

  prePatch = ''
    sed -E -i "s/'([[:alnum:].-]+)[=><][[:digit:]=><.,]*'/'\\1'/g" setup.py
  '';

  # Unnecessary, and causes some really weird behavior around .class files, which
  # this package bundles. See https://github.com/NixOS/nixpkgs/issues/22520.
  dontStrip = true;

  propagatedBuildInputs = [
    twitter-common-collections setproctitle ansicolors packaging pathspec
    scandir twitter-common-dirutil psutil requests pystache pex docutils
    markdown pygments twitter-common-confluence fasteners pywatchman
    futures cffi subprocess32 contextlib2 faulthandler pyopenssl wheel
  ];

  meta = {
    description = "A build system for software projects in a variety of languages";
    homepage    = "https://www.pantsbuild.org/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.unix;
  };
}
