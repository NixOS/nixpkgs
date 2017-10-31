{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
  name = "mxu11x0-1.3.11+git2017-07-13-${kernel.version}";

  src = fetchFromGitHub {
    owner = "ellysh";
    repo = "mxu11x0";
    rev = "cbbb5ec2045939209117cb5fcd6c7c23bcc109ef";
    sha256 = "0wf44pnz5aclvg2k1f8ljnwws8hh6191i5h06nz95ijbxhwz63w4";
  };

  preBuild = ''
    sed -i -e "s/\$(uname -r).*/${kernel.modDirVersion}/g" driver/mxconf
    sed -i -e "s/\$(shell uname -r).*/${kernel.modDirVersion}/g" driver/Makefile
    sed -i -e 's|/lib/modules|${kernel.dev}/lib/modules|' driver/mxconf
    sed -i -e 's|/lib/modules|${kernel.dev}/lib/modules|' driver/Makefile
  '';
  
  installPhase = ''
    install -v -D -m 644 ./driver/mxu11x0.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/usb/serial/mxu11x0.ko"
    install -v -D -m 644 ./driver/mxu11x0.ko "$out/lib/modules/${kernel.modDirVersion}/misc/mxu11x0.ko"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  hardeningDisable = [ "pic" ];

  meta = with stdenv.lib; {
    description = "MOXA UPort 11x0 USB to Serial Hub driver";
    homepage = https://github.com/ellysh/mxu11x0;
    license = licenses.gpl1;
    maintainers = with maintainers; [ uralbash ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "4.9" || !versionOlder kernel.version "4.13";
  };
}
