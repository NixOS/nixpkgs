{
  mkKdeDerivation,
  kpmcore,
}:
mkKdeDerivation {
  pname = "partitionmanager";

  outputs = [
    "out"
    "doc"
  ];

  propagatedUserEnvPkgs = [ kpmcore ];

  passthru = {
    inherit kpmcore;
  };

  meta.mainProgram = "partitionmanager";
}
