{ stdenv, pythonPackages }:

with stdenv.lib;
with pythonPackages;

let
  version = "1.7.0";
in buildPythonApplication rec {
  inherit version;
  pname = "pantsbuild.pants";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d7ff1383287c8e72f2c9855cfef982d362274a64e2707a93c070f988ba80a37";
  };

  prePatch = ''
    sed -E -i "s/'([[:alnum:].-]+)[=><][[:digit:]=><.,]*'/'\\1'/g" setup.py
    substituteInPlace setup.py --replace "requests[security]<2.19,>=2.5.0" "requests[security]<2.20,>=2.5.0"
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
