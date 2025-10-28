{ torchtnt, fetchPypi }:
torchtnt.overridePythonAttrs rec {
  pname = "torchtnt-nightly";
  version = "2024.8.1";

  src = fetchPypi {
    pname = "torchtnt_nightly";
    inherit version;
    hash = "sha256-tRG0mvnMWGBlEUFu02ja2h549TBiIfeSMjwHMyaLZjw=";
  };
}
