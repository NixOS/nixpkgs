{
  stdenv,
  lib,
  fetchurl,
  patchelf,
  zlib,
  glibc,
  versionCheckHook,
  version,
  hash,
}:

let
  sys = lib.concatStringsSep "-" (lib.reverseList (lib.splitString "-" stdenv.system));
  bsys = builtins.replaceStrings [ "_" ] [ "-" ] sys;
  ldd = (lib.getBin glibc) + "/bin/ldd";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "fabricmanager";
  inherit version;

  src = fetchurl {
    url =
      "https://developer.download.nvidia.com/compute/nvidia-driver/redist/fabricmanager/"
      + "${sys}/${finalAttrs.pname}-${sys}-${finalAttrs.version}-archive.tar.xz";
    inherit hash;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/nvidia-fabricmanager}
    for bin in nv{-fabricmanager,switch-audit};do
      ${patchelf}/bin/patchelf \
        --set-interpreter ${stdenv.cc.libc}/lib/ld-${bsys}.so.2 \
        --set-rpath ${
          lib.makeLibraryPath [
            stdenv.cc.libc
            zlib
          ]
        } \
        bin/$bin
    done
    mv bin/nv{-fabricmanager,switch-audit} $out/bin/.
    for d in etc systemd share/nvidia;do
      mv $d $out/share/nvidia-fabricmanager/.
    done
    for d in include lib;do
      mv $d $out/.
    done
    patchShebangs $out/bin

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    for b in $out/bin/*;do
      ${ldd} $b | grep -vqz "not found"
    done

    runHook postCheck
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  # Default stdenv fixup shrinkings cause undefined symbols when trying to run
  # meta.mainProgram
  dontFixup = true;

  meta = {
    homepage = "https://www.nvidia.com/object/unix.html";
    description = "Fabricmanager daemon for NVLink intialization and control";
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "nv-fabricmanager";
    maintainers = with lib.maintainers; [ edwtjo ];
  };
})
