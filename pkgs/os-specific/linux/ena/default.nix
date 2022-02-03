{ lib, stdenv, fetchFromGitHub, kernel, fetchpatch }:

stdenv.mkDerivation rec {
  version = "2.6.1";
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "ena_linux_${version}";
    sha256 = "sha256-lvFsZGzgiD0YRrPFDa6EjM2b/IBRzN6nhc8I1j2Ptm8=";
  };

  patches = [
    # kernel 5.15 support https://github.com/amzn/amzn-drivers/pull/204
    (fetchpatch {
      url = "https://github.com/amzn/amzn-drivers/pull/204/commits/0f971febfa14bdd461e89c5ba940b429275720a5.patch";
      sha256 = "sha256-Hyr3e0jPEy9/e8Fr5hgnLq0HZuVmyQBWWPLWh+GmqBc=";
    })
  ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # linux 3.12
  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  configurePhase = ''
    runHook preConfigure
    cd kernel/linux/ena
    substituteInPlace Makefile --replace '/lib/modules/$(BUILD_KERNEL)' ${kernel.dev}/lib/modules/${kernel.modDirVersion}
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    strip -S ena.ko
    dest=$out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $dest
    cp ena.ko $dest/
    xz $dest/ena.ko
    runHook postInstall
  '';

  meta = with lib; {
    description = "Amazon Elastic Network Adapter (ENA) driver for Linux";
    homepage = "https://github.com/amzn/amzn-drivers";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.5";
  };
}
