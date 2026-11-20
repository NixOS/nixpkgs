{
  stdenvNoCC,
  lndir,
  authenticodeCheckHook,
  fwupd-efi,
  autopen,
  uefiSigningKey,
  uefiCertificate,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "${finalAttrs.unsigned.pname}-signed";
  inherit (finalAttrs.unsigned) version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    lndir
    authenticodeCheckHook
  ];

  authenticodeCertificate = uefiCertificate;

  unsigned = fwupd-efi;

  pePath = "libexec/fwupd/efi/fwupd${stdenvNoCC.hostPlatform.efiArch}.efi";

  signedPe = autopen.authenticode.mkSignedPe {
    inherit (finalAttrs.unsigned) pname version;
    signingKey = uefiSigningKey;
    certificate = uefiCertificate;
    peFile = "${finalAttrs.unsigned}/${finalAttrs.pePath}";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p -- "$out/lib/pkgconfig"
    substitute \
      "$unsigned/lib/pkgconfig/fwupd-efi.pc" \
      "$out/lib/pkgconfig/fwupd-efi.pc" \
      --replace-fail "$unsigned" "$out"
    lndir "$unsigned" "$out"
    ln -sf -- "$signedPe" "$out/$pePath"

    runHook postInstall
  '';

  strictDeps = true;

  __structuredAttrs = true;

  meta = fwupd-efi.meta // {
    description = "${fwupd-efi.meta.description} (signed)";
  };
})
