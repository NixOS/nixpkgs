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

<<<<<<< HEAD
  meta = {
    description = "First stage minimal scriptable build tool for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
=======
  meta = with lib; {
    description = "First stage minimal scriptable build tool for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = licenses.gpl3Plus;
    teams = [ teams.minimal-bootstrap ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit platforms;
  };
}
