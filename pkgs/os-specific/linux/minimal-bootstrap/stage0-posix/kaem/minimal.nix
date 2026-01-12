{
  lib,
  derivationWithMeta,
  src,
  hex0,
  version,
  platforms,
  stage0Arch,
}:
derivationWithMeta {
  inherit version;
  pname = "kaem-minimal";
  builder = hex0;
  args = [
    "${src}/${stage0Arch}/kaem-minimal.hex0"
    (placeholder "out")
  ];

  meta = {
    description = "First stage minimal scriptable build tool for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    inherit platforms;
  };
}
