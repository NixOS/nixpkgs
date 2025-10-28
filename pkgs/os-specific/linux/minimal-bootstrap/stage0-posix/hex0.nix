{
  lib,
  derivationWithMeta,
  hostPlatform,
  src,
  version,
  platforms,
  stage0Arch,
}:

let
  hash =
    {
      "AArch64" = "sha256-XTPsoKeI6wTZAF0UwEJPzuHelWOJe//wXg4HYO0dEJo=";
      "AMD64" = "sha256-RCgK9oZRDQUiWLVkcIBSR2HeoB+Bh0czthrpjFEkCaY=";
      "x86" = "sha256-QU3RPGy51W7M2xnfFY1IqruKzusrSLU+L190ztN6JW8=";
    }
    .${stage0Arch} or (throw "Unsupported system: ${hostPlatform.system}");

  # Pinned from https://github.com/oriansj/stage0-posix/commit/3189b5f325b7ef8b88e3edec7c1cde4fce73c76c
  # This 256 byte seed is the only pre-compiled binary in the bootstrap chain.
  hex0-seed = import <nix/fetchurl.nix> {
    name = "hex0-seed";
    url = "https://github.com/oriansj/bootstrap-seeds/raw/b1263ff14a17835f4d12539226208c426ced4fba/POSIX/${stage0Arch}/hex0-seed";
    executable = true;
    inherit hash;
  };
in
derivationWithMeta {
  inherit version;
  pname = "hex0";
  builder = hex0-seed;
  args = [
    "${src}/${stage0Arch}/hex0_${stage0Arch}.hex0"
    (placeholder "out")
  ];

  meta = with lib; {
    description = "Minimal assembler for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = licenses.gpl3Plus;
    teams = [ teams.minimal-bootstrap ];
    inherit platforms;
  };

  passthru = { inherit hex0-seed; };

  # Ensure the untrusted hex0-seed binary produces a known-good hex0
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = hash;
}
