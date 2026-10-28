{
  mkKdeDerivation,
  kpmcore,
}:
mkKdeDerivation {
  pname = "partitionmanager";

  propagatedUserEnvPkgs = [ kpmcore ];

  passthru = {
    inherit kpmcore;
  };

  meta.mainProgram = "partitionmanager";
}
