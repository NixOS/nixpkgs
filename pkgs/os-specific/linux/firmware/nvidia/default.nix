{ stdenv, lib, fetchurl, python2Packages, which, xz }:
let
  extractor = fetchurl {
    url = "https://raw.githubusercontent.com/imirkin/re-vp2/d19d818d1e05c7c68afb052073cc8a487cac8f5d/extract_firmware.py";
    sha256 = "sha256-FUu/aeWTtAdEj820x4BEZKgn3Zxs3hBI7EhLBmgMrQ0=";
  };

  # there is firmware for additional models in the package from nvidia, but these are the only ones that have been tested.
  chipModel = [
    { chip = "nve4"; model = "gk104"; }
    { chip = "nve6"; model = "gk106"; }
    { chip = "nve7"; model = "gk107"; }
  ];

in
stdenv.mkDerivation rec {
  pname = "linux-firmware-nvidia";
  version = "325.15";

  src = fetchurl {
    url = "http://us.download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}.run";
    sha256 = "sha256-PXkOS/7SRkH3zHaHkUSrXVKxInEBK6OBsNM6oaLgh3U=";
  };

  nativeBuildInputs = [ which xz ];

  unpackPhase = ''
    ${stdenv.shell} ${src} --extract-only
    ${python2Packages.python.interpreter} ${extractor}
  '';

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    dir=$out/lib/firmware

    mkdir -p $dir/{nouveau,nvidia}
    cp -rd nv* vuc-* $dir/nouveau

  '' + lib.concatStringsSep "\n" (map
    (entry: ''
      mkdir -p $dir/nvidia/${entry.model}

      ln -rs $dir/nouveau/${entry.chip}_fuc409c $dir/nvidia/${entry.model}/fecs_inst.bin
      ln -rs $dir/nouveau/${entry.chip}_fuc409d $dir/nvidia/${entry.model}/fecs_data.bin
      ln -rs $dir/nouveau/${entry.chip}_fuc41ac $dir/nvidia/${entry.model}/gpccs_inst.bin
      ln -rs $dir/nouveau/${entry.chip}_fuc41ad $dir/nvidia/${entry.model}/gpccs_data.bin
    '')
    chipModel) + ''

    runHook postInstall
  '';

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  meta = with lib; {
    description = "Binary firmware for nVidia cards";
    longDescription = ''
      This package contains proprietary firmware blobs for nVidia graphics cards
      up to and including the "Kepler" range.

      If you card is supported but not handled by this package, please find your
      here https://nouveau.freedesktop.org/wiki/CodeNames/ and let us know.
    '';
    homepage = "https://nvidia.com";
    hydraPlatforms = [ ];
    license = licenses.unfree;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
