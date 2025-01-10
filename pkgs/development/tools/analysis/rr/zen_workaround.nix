{
  stdenv,
  lib,
  kernel,
  rr,
}:

/*
  The python script shouldn't be needed for users of this kernel module.
  https://github.com/rr-debugger/rr/blob/master/scripts/zen_workaround.py
  The module itself is called "zen_workaround" (a bit generic unfortunately).
*/
stdenv.mkDerivation {
  pname = "rr-zen_workaround";

  inherit (rr) src version;
  sourceRoot = "source/third-party/zen-pmu-workaround";

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];
  postConfigure = ''
    appendToVar makeFlags "M=$(pwd)"
  '';
  buildFlags = [ "modules" ];

  installPhase =
    let
      modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel"; # TODO: longer path?
    in
    ''
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
