{ stdenv, lib, fetchzip, kernel }:

/* The python script shouldn't be needed for users of this kernel module.
  https://github.com/rr-debugger/rr/blob/master/scripts/zen_workaround.py
  The module itself is called "zen_workaround" (a bit generic unfortunately).
*/
stdenv.mkDerivation rec {
  pname = "rr-zen_workaround";
  version = "2020-09-22";

  src = fetchzip {
    url = "https://gist.github.com/glandium/01d54cefdb70561b5f6675e08f2990f2/archive/2f430f0c136a69b0886281d0c76708997d8878af.zip";
    sha256 = "1mbmbyymgl75wparv3rgnyxnc44rd6n935jziz9anl9apy031ryi";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];
  postConfigure = ''
    makeFlags="$makeFlags M=$(pwd)"
  '';
  buildFlags = [ "modules" ];

  installPhase = let
    modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel"; #TODO: longer path?
  in ''
    runHook preInstall
    mkdir -p "${modDestDir}"
    cp *.ko "${modDestDir}/"
    find ${modDestDir} -name '*.ko' -exec xz -f '{}' \;
    runHook postInstall
  '';

  meta = with lib; {
    description = "Kernel module supporting the rr debugger on (some) AMD Zen-based CPUs";
    homepage = "https://github.com/rr-debugger/rr/wiki/Zen#kernel-module";
    license = licenses.gpl2;
    maintainers = [ maintainers.vcunat ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "4.19"; # 4.14 breaks and 4.19 works
  };
}
