{
  lib,
  mkKdeDerivation,
  replaceVars,
  openssl,
  pkg-config,
  qtwayland,
  freerdp,
  libei,
  pam,
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
    libei
    pam
  ];

  # Hardcoded as QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${lib.getExe openssl}" > $out/nix-support/depends
  '';
}
