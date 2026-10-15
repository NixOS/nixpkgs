{
  lib,
  mkDerivation,
  libjail,
}:
mkDerivation {
  path = "usr.sbin/jexec";
  buildInputs = [
    libjail
  ];
  meta.mainProgram = "jexec";
}
