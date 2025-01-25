{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "r8126";
  # On update please verify (using `diff -r`) that the source matches the
  # realtek version.
  version = "10.014.01";

  # This is a mirror. The original website[1] doesn't allow non-interactive
  # downloads.
  # [1] https://www.realtek.com/Download/List?cate_id=584
  src = fetchFromGitHub {
    owner = "openwrt";
    repo = "rtl8126";
    tag = finalAttrs.version;
    hash = "sha256-NSi95L5PN+o9z7N3zFjcYk2nQjY03csUBp0saakaqlE=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    substituteInPlace Makefile --replace-fail "BASEDIR :=" "BASEDIR ?="
    substituteInPlace Makefile --replace-fail "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  '';

  makeFlags = [
    "BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  buildFlags = [ "modules" ];

  meta = {
    homepage = "https://github.com/openwrt/rtl8126";
    downloadPage = "https://www.realtek.com/Download/List?cate_id=584";
    description = "Realtek r8126 driver";
    longDescription = ''
      A kernel module for Realtek 8126 5G network cards.
    '';
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.davidkna ];
  };
})
