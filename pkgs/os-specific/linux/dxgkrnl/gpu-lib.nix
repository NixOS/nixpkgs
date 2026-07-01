{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  msitools,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wsl-gpu-lib";
  version = "2.6.3";

  src = fetchurl {
    url = "https://github.com/microsoft/WSL/releases/download/${version}/Microsoft.WSL_${version}.0_x64_ARM64.msixbundle";
    hash = "sha256-e+etYLgk6bbdiqxhw2woBDaSgc8m+P133ojUPJNoY10=";
  };

  nativeBuildInputs = [
    unzip
    msitools
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    # MSIX bundle → x64 MSIX → MSI → .so files
    unzip -o $src "Microsoft.WSL_${version}.0_x64.msix" -d $TMPDIR
    unzip -o $TMPDIR/Microsoft.WSL_${version}.0_x64.msix wsl.msi -d $TMPDIR
    mkdir -p $TMPDIR/msi-out
    msiextract -C $TMPDIR/msi-out $TMPDIR/wsl.msi

    mkdir -p $out/lib
    cp $TMPDIR/msi-out/PFiles64/WSL/lib/libdxcore.so $out/lib/
    cp $TMPDIR/msi-out/PFiles64/WSL/lib/libd3d12.so $out/lib/
    cp $TMPDIR/msi-out/PFiles64/WSL/lib/libd3d12core.so $out/lib/

    # Case-insensitive symlink needed by some applications
    ln -s libd3d12core.so $out/lib/libD3D12Core.so

    runHook postInstall
  '';

  meta = {
    description = "DirectX GPU libraries for WSL/Hyper-V GPU paravirtualization";
    homepage = "https://github.com/microsoft/WSL";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ lostmsu ];
    platforms = [ "x86_64-linux" ];
  };
}
