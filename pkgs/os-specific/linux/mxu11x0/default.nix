{ stdenv, fetchFromGitHub, kernel }:

# it doesn't compile anymore on 3.14
assert stdenv.lib.versionAtLeast kernel.version "3.18";

stdenv.mkDerivation {
  name = "mxu11x0-1.3.11-${kernel.version}";

  src = fetchFromGitHub {
    owner = "ellysh";
    repo = "mxu11x0";
    rev = "de54053d6f297785d77aba9e9c880001519ffddf";
    sha256 = "1zmqanw22pgaj3b3lnciq33w6svm5ngg6g0k5xxwwijixg8ri3lf";
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
  };
}
