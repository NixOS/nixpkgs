{ stdenv, lib, fetchFromGitHub, makeWrapper
, apk-tools, coreutils, e2fsprogs, findutils, gnugrep, gnused, kmod, qemu-utils
, utillinux
}:

stdenv.mkDerivation rec {
  pname = "alpine-make-vm-image";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-vm-image";
    rev = "v${version}";
    sha256 = "0955kd2ddqfynjwk2xfzys96l7abxp30hhrs2968hl78rhmkvpnq";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/alpine-make-vm-image --set PATH ${lib.makeBinPath [
      apk-tools coreutils e2fsprogs findutils gnugrep gnused kmod qemu-utils
      utillinux
    ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/alpinelinux/alpine-make-vm-image";
    description = "Make customized Alpine Linux disk image for virtual machines";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
