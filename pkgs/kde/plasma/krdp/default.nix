{
  lib,
  mkKdeDerivation,
  replaceVars,
  openssl,
  pam,
  pkg-config,
  qtwayland,
  freerdp,
}:
mkKdeDerivation {
  pname = "krdp";

  patches = [
    (replaceVars ./hardcode-openssl-path.patch {
      openssl = lib.getExe openssl;
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwayland

    freerdp
    pam
  ];
}
