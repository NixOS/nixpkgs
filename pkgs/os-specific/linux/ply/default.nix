{ lib, stdenv, kernel, fetchFromGitHub, autoreconfHook, bison, flex, p7zip, rsync }:

assert kernel != null -> lib.versionAtLeast kernel.version "4.0";

let
  version = "2.1.1";
in stdenv.mkDerivation {
  pname = "ply";
  inherit version;
  nativeBuildInputs = [ autoreconfHook flex bison p7zip rsync ];

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "ply";
    rev = "899afb0c35ba2191dd7aa21f13bc7fde2655c475";
    sha256 = "0mfnfczk6kw6p15nx5l735qmcnb0pkix7ngq0j8nndg7r2fsckah";
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
    license = [ licenses.gpl2 ];
    maintainers = with maintainers; [ mic92 mbbx6spp ];
  };
}
