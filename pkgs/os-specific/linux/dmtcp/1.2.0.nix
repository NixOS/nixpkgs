{stdenv, fetchurl, perl, python}:
# Perl and Python required by the test suite.

stdenv.mkDerivation rec {
  name = "dmtcp-${version}";

  version = "1.2.0";

  buildInputs = [ perl python ];

  src = fetchurl {
    url = "mirror://sourceforge/dmtcp/dmtcp_${version}.tar.gz";
    sha256 = "1pw3m4l1xf887xagd0yrrnb35s372j0kvjziyy3gmx9fxpga1jzb";
  };

  preConfigure = ''
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

  doCheck = true;

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
