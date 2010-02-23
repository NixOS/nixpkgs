{stdenv, fetchsvn, perl, python}:

# Perl and python are needed in order to run the test suite.

let
  revision = "512";
in

stdenv.mkDerivation {
  name = "dmtcp-devel-${revision}";

  src = fetchsvn {
    url = https://dmtcp.svn.sourceforge.net/svnroot/dmtcp/trunk;
    rev = revision;
    sha256 = "77d8fe7f39d661669a58c6bf789886a8b6c8186d68d2b95d8a8791efab2c03b7";
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
