{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "r8125";
  # On update please verify (using `diff -r`) that the source matches the
  # realtek version.
  version = "9.003.02";

  # This is a mirror. The original website[1] doesn't allow non-interactive
  # downloads, instead emailing you a download link.
  # [1] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
  src = fetchFromGitHub {
    owner = "ibmibmibm";
    repo = "r8125";
    rev = "${version}";
    sha256 = "09ip17x8nhcpxkkhyyawkmd10n73j2ffh1i2nmsr7l3jfq7f9zac";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    substituteInPlace src/Makefile --replace "BASEDIR :=" "BASEDIR ?="
    substituteInPlace src/Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  '';

  makeFlags = [
    "BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  buildFlags = [ "modules" ];

  meta = with lib; {
    homepage = "https://github.com/ibmibmibm/r8125";
    downloadPage = "https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software";
    description = "Realtek r8125 driver";
    longDescription = ''
      A kernel module for Realtek 8125 2.5G network cards.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peelz ];
  };
}
