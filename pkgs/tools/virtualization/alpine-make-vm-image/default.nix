{ stdenv, lib, fetchFromGitHub, makeWrapper
, apk-tools, coreutils, e2fsprogs, findutils, gnugrep, gnused, kmod, qemu-utils
, rsync, util-linux
}:

stdenv.mkDerivation rec {
  pname = "alpine-make-vm-image";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-vm-image";
    rev = "v${version}";
    sha256 = "sha256-nFgzi8jotwsP5ZG13DrBo+FMNmWNSDiKIbVF6hVtYRU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/alpine-make-vm-image --set PATH ${lib.makeBinPath [
      apk-tools coreutils e2fsprogs findutils gnugrep gnused kmod qemu-utils
      rsync util-linux
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
