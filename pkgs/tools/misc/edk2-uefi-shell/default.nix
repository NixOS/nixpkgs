{ lib
, edk2
, util-linux
, nasm
, python3
}:
edk2.mkDerivation "ShellPkg/ShellPkg.dsc" (finalAttrs: {
  pname = "edk2-uefi-shell";
  inherit (edk2) version;

  nativeBuildInputs = [ util-linux nasm python3 ];
  strictDeps = true;

  # We only have a .efi file in $out which shouldn't be patched or stripped
  dontPatchELF = true;
  dontStrip = true;

  # GUID hardcoded to match ShellPkg.dsc
  installPhase = ''
    runHook preInstall
    install -D -m0644 Build/Shell/RELEASE*/*/Shell_EA4BB293-2D7F-4456-A681-1F22F42CD0BC.efi $out/shell.efi
    runHook postInstall
  '';

  passthru.efi = "${finalAttrs.finalPackage}/shell.efi";

  meta = {
    inherit (edk2.meta) license platforms;
    description = "UEFI Shell from Tianocore EFI development kit";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/ShellPkg";
    maintainers = with lib.maintainers; [ LunNova ];
  };
})
