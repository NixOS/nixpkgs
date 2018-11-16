{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "nvidiabl-${version}-${kernel.version}";
  version = "2017-09-26";

  # We use a fork which adds support for newer kernels -- upstream has been abandoned.
  src = fetchFromGitHub {
    owner = "yorickvP";
    repo = "nvidiabl";
    rev = "2d909f4dfceb24ce98479fd571411c6ec3b71bea";
    sha256 = "0dsar8fsaxwywjh6rbrxkhdp142vqjnsyxfz6bgpbqml6slpiqs1";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    sed -i 's|/sbin/depmod|#/sbin/depmod|' Makefile
  '';

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=$(out)"
    "KVER=${kernel.modDirVersion}"
  ];

  meta = with stdenv.lib; {
    description = "Linux driver for setting the backlight brightness on laptops using NVIDIA GPU";
    homepage = https://github.com/guillaumezin/nvidiabl;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ yorickvp ];
  };
}
