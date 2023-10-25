{ lib
, derivationWithMeta
, hex0-seed
, src
, version
}:
derivationWithMeta {
  inherit version;
  pname = "hex0";
  builder = hex0-seed;
  args = [
    "${src}/x86/hex0_x86.hex0"
    (placeholder "out")
  ];

  meta = with lib; {
    description = "Minimal assembler for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = [ "i686-linux" ];
  };

  # Ensure the untrusted hex0-seed binary produces a known-good hex0
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-QU3RPGy51W7M2xnfFY1IqruKzusrSLU+L190ztN6JW8=";
}
