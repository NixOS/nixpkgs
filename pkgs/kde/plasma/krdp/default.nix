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
      openssl = openssl.exe;
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwayland

    freerdp
    pam
  ];

  # Hardcoded as QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${openssl.exe}" > $out/nix-support/depends
  '';
}
