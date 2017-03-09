{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dmtcp-${version}";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "dmtcp";
    repo = "dmtcp";
    rev = version;
    sha256 = "08l774i8yp41j6kmzhj7x13475m5kdfhn678ydpm5cbg4l3dda3c";
  };

  dontDisableStatic = true;

  postPatch = ''
    substituteInPlace configure \
      --replace '#define ELF_INTERPRETER "$interp"' \
                "#define ELF_INTERPRETER \"$(cat $NIX_CC/nix-support/dynamic-linker)\""
  '';

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
