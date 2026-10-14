{
  lib,
  stdenvNoCC,
  lndir,
  authenticodeCheckHook,
  shim-unsigned,
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

  unsigned = shim-unsigned.override {
    vendorCertFile = uefiCertificate;
    defaultLoader = "\\\\systemd-boot${stdenvNoCC.hostPlatform.efiArch}.efi";
  };

  signedPes =
    lib.genAttrs
      [
        finalAttrs.unsigned.target
        finalAttrs.unsigned.mokManagerTarget
        finalAttrs.unsigned.fallbackTarget
      ]
      (
        peName:
        autopen.authenticode.mkSignedPe {
          inherit (finalAttrs.unsigned) pname version;
          signingKey = uefiSigningKey;
          certificate = uefiCertificate;
          peFile = "${finalAttrs.unsigned}/share/shim/${peName}";
        }
      );

  installPhase = ''
    runHook preInstall

    mkdir -- "$out"
    lndir "$unsigned" "$out"
    for peName in "''${!signedPes[@]}"; do
      ln -sf -- "''${signedPes[$peName]}" "$out/share/shim/$peName"
    done

    runHook postInstall
  '';

  strictDeps = true;

  __structuredAttrs = true;

  meta = shim-unsigned.meta // {
    description = "${shim-unsigned.meta.description} (signed)";
  };
})
