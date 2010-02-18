{stdenv, fetchsvn, perl, python}:

# Perl and python are needed in order to run the test suite.

let
  revision = "495";
in

stdenv.mkDerivation {
  name = "dmtcp-devel-${revision}";

  src = fetchsvn {
    url = https://dmtcp.svn.sourceforge.net/svnroot/dmtcp/trunk;
    rev = revision;
    sha256 = "25991cc079942c51fc3cf279b24ef481810cfa0305c8a92f215711d4308a40f7";
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
