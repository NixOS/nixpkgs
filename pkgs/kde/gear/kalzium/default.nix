{
  mkKdeDerivation,
  pkg-config,
  ocaml,
  eigen,
  openbabel,
  qtsvg,
  qtscxml,
}:
mkKdeDerivation {
  pname = "kalzium";

  # FIXME: look into how to make it find libfacile
  extraNativeBuildInputs = [
    pkg-config
    ocaml
  ];
  extraBuildInputs = [
    eigen
    openbabel
    qtsvg
    qtscxml
  ];
  meta.mainProgram = "kalzium";
}
