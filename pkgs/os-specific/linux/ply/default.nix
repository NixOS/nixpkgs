{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  p7zip,
  rsync,
}:

stdenv.mkDerivation rec {
  pname = "ply";
  version = "2.4.0";

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
    p7zip
    rsync
  ];

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "ply";
    tag = "${version}";
    sha256 = "sha256-PJaCEiM1BRUEtInd93bK+xZNJzO9EZy+JXkp9cdPrgs=";
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
    mainProgram = "ply";
    homepage = "https://wkz.github.io/ply/";
    license = [ licenses.gpl2Only ];
    maintainers = with maintainers; [
      mic92
      mbbx6spp
    ];
  };
}
