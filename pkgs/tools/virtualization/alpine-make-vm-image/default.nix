{ stdenv, lib, fetchFromGitHub, makeWrapper
, apk-tools, coreutils, e2fsprogs, findutils, gnugrep, gnused, kmod, qemu-utils
<<<<<<< HEAD
, rsync, util-linux
=======
, util-linux
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "alpine-make-vm-image";
<<<<<<< HEAD
  version = "0.11.1";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-vm-image";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-nFgzi8jotwsP5ZG13DrBo+FMNmWNSDiKIbVF6hVtYRU=";
=======
    sha256 = "sha256-WxuExPn+ni4F7hxO1hrrYGm1hsehX8EcaOGevbrHKDM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/alpine-make-vm-image --set PATH ${lib.makeBinPath [
      apk-tools coreutils e2fsprogs findutils gnugrep gnused kmod qemu-utils
<<<<<<< HEAD
      rsync util-linux
=======
      util-linux
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
