{ lib, stdenv, kernel, fetchFromGitHub, autoreconfHook, bison, flex, p7zip, rsync }:

stdenv.mkDerivation rec {
  pname = "ply";
  version = "2.1.1-${lib.substring 0 7 src.rev}";

  nativeBuildInputs = [ autoreconfHook flex bison p7zip rsync ];

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "ply";
    rev = "e25c9134b856cc7ffe9f562ff95caf9487d16b59";
    sha256 = "1178z7vvnjwnlxc98g2962v16878dy7bd0b2njsgn4vqgrnia7i5";
  };

  preAutoreconf = ''
    # If kernel sources are a folder (i.e. fetched from git), we just copy them in
    # Since they are owned by uid 0 and read-only, we need to fix permissions
    if [ -d ${kernel.src} ]; then
      cp -r ${kernel.src} linux-${kernel.version}
      chown -R $(whoami): linux-${kernel.version}
      chmod -R a+w linux-${kernel.version}
    else
      # ply wants to install header files to its build directory
      # use 7z to handle multiple archive formats transparently
      7z x ${kernel.src} -so | 7z x -aoa -si -ttar
    fi

    configureFlagsArray+=(--with-kerneldir=$(echo $(pwd)/linux-*))
    ./autogen.sh --prefix=$out
  '';

  meta = with lib; {
    description = "Dynamic tracing in Linux";
    homepage = "https://wkz.github.io/ply/";
    license = [ licenses.gpl2Only ];
    maintainers = with maintainers; [ mic92 mbbx6spp ];
  };
}
