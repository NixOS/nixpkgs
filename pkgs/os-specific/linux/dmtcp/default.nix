{stdenv, fetchurl, perl, python}:

# Perl and python are needed in order to run the test suite.

let
  pname = "dmtcp";
  version = "1.1.3";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}_${version}.tar.gz";
    sha256 = "0lx455hvxqa9rj83nms9mi6v5klswsrgj8hxhidhi9i2qkx88158";
  };

  buildInputs = [ perl python ];

  doCheck = true;

  preCheck = ''
    substituteInPlace dmtcp/src/dmtcp_coordinator.cpp \
      --replace /bin/bash /bin/sh
    substituteInPlace utils/gdb-add-symbol-file \
      --replace /bin/bash /bin/sh
    substituteInPlace test/autotest.py \
      --replace /usr/bin/env $(type -p env) \
      --replace /bin/bash $(type -p bash) \
      --replace /usr/bin/perl $(type -p perl) \
      --replace /usr/bin/python $(type -p python)
  '';

  meta = {
    description = "Distributed MultiThreaded Checkpointing";
    longDescription = ''
      DMTCP (Distributed MultiThreaded Checkpointing) is a tool to
      transparently checkpointing the state of an arbitrary group of
      programs spread across many machines and connected by sockets. It does
      not modify the user's program or the operating system.
    '';
    homepage = http://dmtcp.sourceforge.net/;
    license = "LGPL";
  };
}
