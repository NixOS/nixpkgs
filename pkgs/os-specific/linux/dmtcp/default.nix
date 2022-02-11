{ lib, stdenv, fetchFromGitHub, bash, perl, python2 }:

# There are fixes for python3 compatibility on master

stdenv.mkDerivation rec {
  pname = "dmtcp";
  version = "unstable-2021-03-01";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "f999adbb8e88fe452a0e57ceb43b6eed7b4409f9";
    sha256 = "sha256-codCHQui3fGfUZSNq8GuH4ad/GjD6I/S9rX83o8oFPc=";
  };

  dontDisableStatic = true;

  patches = [ ./ld-linux-so-buffer-size.patch ];

  postPatch = ''
    patchShebangs .

    substituteInPlace configure \
      --replace '#define ELF_INTERPRETER "$interp"' \
                "#define ELF_INTERPRETER \"$(cat $NIX_CC/nix-support/dynamic-linker)\""
    substituteInPlace src/restartscript.cpp \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace util/dmtcp_restart_wrapper.sh \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace test/autotest.py \
      --replace /bin/bash ${bash}/bin/bash \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace /usr/bin/python ${python2}/bin/python \
      --replace "os.environ['USER']" "\"nixbld1\"" \
      --replace "os.getenv('USER')" "\"nixbld1\""
  '';

  meta = with lib; {
    description = "Distributed MultiThreaded Checkpointing";
    longDescription = ''
      DMTCP (Distributed MultiThreaded Checkpointing) is a tool to
      transparently checkpointing the state of an arbitrary group of
      programs spread across many machines and connected by sockets. It does
      not modify the user's program or the operating system.
    '';
    homepage = "http://dmtcp.sourceforge.net/";
    license = licenses.lgpl3Plus; # most files seem this or LGPL-2.1+
    platforms = intersectLists platforms.linux platforms.x86; # broken on ARM and Darwin
  };
}
