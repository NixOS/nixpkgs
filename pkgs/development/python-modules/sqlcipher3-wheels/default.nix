{
  mkPythonMetaPackage,
  sqlcipher3,
}:
mkPythonMetaPackage {
  pname = "sqlcipher3-wheels";
  inherit (sqlcipher3) version;
  dependencies = [ sqlcipher3 ];
  optional-dependencies = sqlcipher3.optional-dependencies or { };
  meta = {
    inherit (sqlcipher3.meta) description homepage license;
  };
}
