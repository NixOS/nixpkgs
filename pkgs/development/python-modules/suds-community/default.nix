{
  mkPythonMetaPackage,
  suds,
}:

mkPythonMetaPackage {
  pname = "suds-community";
  inherit (suds) version;
  dependencies = [ suds ];
  optional-dependencies = suds.optional-dependencies or { };
  # No src of its own, the version comes from suds
  passthru.updateScript = null;
  meta = {
    inherit (suds.meta) changelog description homepage;
  };
}
