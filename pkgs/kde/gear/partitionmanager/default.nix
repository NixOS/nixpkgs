{
  mkKdeDerivation,
  kpmcore,
}:
mkKdeDerivation {
  pname = "partitionmanager";

  propagatedUserEnvPkgs = [kpmcore];
}
