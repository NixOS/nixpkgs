{
  mkKdeDerivation,
  kpmcore,
}:
mkKdeDerivation {
  pname = "partitionmanager";

  propagatedUserEnvPkgs = [kpmcore];
  meta.mainProgram = "partitionmanager";
}
