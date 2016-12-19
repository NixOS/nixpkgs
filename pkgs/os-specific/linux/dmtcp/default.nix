{stdenv, fetchurl, perl, python}:
# Perl and Python required by the test suite.

stdenv.mkDerivation rec {
  name = "dmtcp-${version}";

  version = "2.3.1";

  buildInputs = [ perl python ];

  src = fetchurl {
    url = "mirror://sourceforge/dmtcp/dmtcp-${version}.tar.gz";
    sha256 = "1f83ae112e102d4fbf69dded0dfaa6daeb60c4c0c569297553785a876e95ba15";
  };

  preConfigure = ''
    substituteInPlace src/dmtcp_coordinator.cpp \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace util/gdb-add-symbol-file \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace test/autotest.py \
      --replace /usr/bin/env $(type -p env) \
      --replace /bin/bash $(type -p bash) \
      --replace /usr/bin/perl $(type -p perl) \
      --replace /usr/bin/python $(type -p python) \
      --replace "os.environ['USER']" "\"nixbld1\"" \
      --replace "os.getenv('USER')" "\"nixbld1\""
  '';

  doCheck = false;

  meta = {
    description = "Distributed MultiThreaded Checkpointing";
    longDescription = ''
      DMTCP (Distributed MultiThreaded Checkpointing) is a tool to
      transparently checkpointing the state of an arbitrary group of
      programs spread across many machines and connected by sockets. It does
      not modify the user's program or the operating system.
    '';
    homepage = http://dmtcp.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl3Plus; # most files seem this or LGPL-2.1+
  };
}
