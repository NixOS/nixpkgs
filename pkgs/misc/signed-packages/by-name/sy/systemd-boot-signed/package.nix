{
  lib,
  stdenvNoCC,
  autopen,
  lndir,
  authenticodeCheckHook,
  systemd,
  uefiSigningKey,
  uefiCertificate,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "systemd-boot-signed";
  inherit (finalAttrs.unsigned) version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    lndir
    authenticodeCheckHook
  ];

  authenticodeCertificate = uefiCertificate;

  authenticodeCheckExclude = [
    # UKIs and addons are signed as a whole, not per stub.
    "lib/systemd/boot/efi/*.stub"
  ];

  unsigned = systemd;

  pePath = "lib/systemd/boot/efi/systemd-boot${stdenvNoCC.hostPlatform.efiArch}.efi";

  signedPe = autopen.authenticode.mkSignedPe {
    inherit (finalAttrs.unsigned) pname version;
    signingKey = uefiSigningKey;
    certificate = uefiCertificate;
    peFile = "${finalAttrs.unsigned}/${finalAttrs.pePath}";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/systemd/boot/efi
    lndir {"$unsigned","$out"}/lib/systemd/boot/efi
    ln -sf "$signedPe" "$out/$pePath"

    runHook postInstall
  '';

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "A simple UEFI boot manager (signed)";
    inherit (systemd.meta)
      homepage
      license
      platforms
      badPlatforms
      identifiers
      ;
    teams = systemd.meta.teams ++ [ lib.teams.boot-security ];
  };
})
