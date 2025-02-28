{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "r8125";
  # On update please verify (using `diff -r`) that the source matches the
  # realtek version.
  version = "9.015.00";

  # This is a mirror. The original website[1] doesn't allow non-interactive
  # downloads, instead emailing you a download link.
  # [1] https://www.realtek.com/Download/List?cate_id=584
  src = fetchFromGitHub {
    owner = "notpeelz";
    repo = "r8125";
    rev = version;
    sha256 = "sha256-ceJXSOyAFis2RVhjVhtoGai4/22Si4j1OG083A2jlt0=";
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
    homepage = "https://github.com/notpeelz/r8125";
    downloadPage = "https://www.realtek.com/Download/List?cate_id=584";
    description = "Realtek r8125 2.5G Ethernet driver";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peelz ];
  };
}
