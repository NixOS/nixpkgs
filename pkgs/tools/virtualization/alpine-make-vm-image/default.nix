{ stdenv, lib, fetchFromGitHub, makeWrapper
, apk-tools, coreutils, e2fsprogs, findutils, gnugrep, gnused, kmod, qemu-utils
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "alpine-make-vm-image";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-vm-image";
    rev = "v${version}";
    sha256 = "sha256-WxuExPn+ni4F7hxO1hrrYGm1hsehX8EcaOGevbrHKDM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/alpine-make-vm-image --set PATH ${lib.makeBinPath [
      apk-tools coreutils e2fsprogs findutils gnugrep gnused kmod qemu-utils
      util-linux
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
