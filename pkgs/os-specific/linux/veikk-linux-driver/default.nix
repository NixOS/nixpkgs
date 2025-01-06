{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "veikk-linux-driver";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "jlam55555";
    repo = pname;
    rev = "v${version}";
    sha256 = "11mg74ds58jwvdmi3i7c4chxs6v9g09r9ll22pc2kbxjdnrp8zrn";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel ];

  makeFlags = kernel.makeFlags ++ [
    "BUILD_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/veikk
    install -Dm755 veikk.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/veikk
  '';

  meta = {
    description = "Linux driver for VEIKK-brand digitizers";
    homepage = "https://github.com/jlam55555/veikk-linux-driver/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nicbk ];
    broken = kernel.kernelOlder "4.19";
  };
}
