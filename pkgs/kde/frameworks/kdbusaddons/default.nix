{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kdbusaddons";

  extraNativeBuildInputs = [qttools];
  meta.mainProgram = "kquitapp6";
}
