{ stdenv, fetchFromGitHub, bash, perl, python }:

stdenv.mkDerivation rec {
  name = "dmtcp-${version}";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "dmtcp";
    repo = "dmtcp";
    rev = version;
    sha256 = "1sq38in4wk855yhfnzbs9xpnps97fhja93w08xjmx7szzm33g5a8";
  };

  dontDisableStatic = true;

  patches = [ ./ld-linux-so-buffer-size.patch ];

  postPatch = ''
    patchShebangs .

    substituteInPlace configure \
      --replace '#define ELF_INTERPRETER "$interp"' \
                "#define ELF_INTERPRETER \"$(cat $NIX_CC/nix-support/dynamic-linker)\""
    substituteInPlace src/dmtcp_coordinator.cpp \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace util/gdb-add-symbol-file \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace test/autotest.py \
      --replace /bin/bash ${bash}/bin/bash \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace /usr/bin/python ${python}/bin/python \
      --replace "os.environ['USER']" "\"nixbld1\"" \
      --replace "os.getenv('USER')" "\"nixbld1\""
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
    license = stdenv.lib.licenses.lgpl3Plus; # most files seem this or LGPL-2.1+
  };
}
