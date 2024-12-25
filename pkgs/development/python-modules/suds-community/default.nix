{
  mkPythonMetaPackage,
  suds,
}:

mkPythonMetaPackage {
  pname = "suds-community";
  inherit (suds) version;
  dependencies = [ suds ];
  optional-dependencies = suds.optional-dependencies or { };
  meta = {
    inherit (suds.meta) changelog description homepage;
  };
}
