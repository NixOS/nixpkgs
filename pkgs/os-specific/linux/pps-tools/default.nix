{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  baseName = "pps-tools";
  version = "1.0.2";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "redlab-i";
    repo = baseName;
    rev = "v${version}";
    sha256 = "1yh9g0l59dkq4ci0wbb03qin3c3cizfngmn9jy1vwm5zm6axlxhf";
  };

  outputs = [ "out" "dev" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $dev/include
    mkdir -p $out/{usr/bin,usr/include/sys}
    make install DESTDIR=$out
    mv $out/usr/bin/* $out/bin
    mv $out/usr/include/* $dev/include/
    rm -rf $out/usr/
  '';

  meta = with lib;{
    description = "User-space tools for LinuxPPS";
    homepage = "http://linuxpps.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sorki ];
  };
}
