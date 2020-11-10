{ stdenv, kernel, fetchFromGitHub, autoreconfHook, yacc, flex, p7zip, rsync }:

assert kernel != null -> stdenv.lib.versionAtLeast kernel.version "4.0";

let
  version = "1.0.beta1-9e810b1";
in stdenv.mkDerivation {
  pname = "ply";
  inherit version;
  nativeBuildInputs = [ autoreconfHook flex yacc p7zip rsync ];

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "ply";
    rev = "9e810b157ba079c32c430a7d4c6034826982056e";
    sha256 = "15cp6iczawaqlhsa0af6i37zn5iq53kh6ya8s2hzd018yd7mhg50";
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

  meta = with stdenv.lib; {
    description = "dynamic Tracing in Linux";
    homepage = "https://wkz.github.io/ply/";
    license = [ licenses.gpl2 ];
    maintainers = with maintainers; [ mic92 mbbx6spp ];
  };
}
