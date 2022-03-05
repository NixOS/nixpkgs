{ stdenv, lib, fetchFromGitHub, makeWrapper
, apk-tools, coreutils, e2fsprogs, findutils, gnugrep, gnused, kmod, qemu-utils
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "alpine-make-vm-image";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-vm-image";
    rev = "v${version}";
    sha256 = "14rkqlg319h8agiydgknjfv2f7vl6rdj848xfkngvydrf1rr38j6";
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
