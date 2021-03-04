{ pkgs }:
self: super: {

  rmfuse = super.rmfuse.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/rschroll/rmfuse.git";
        rev = "ac91d477cc32311c88aa7ecd1bebd6503e426ae7";
        sha256 = "129n00hricsf4jkgj39bq3m5nhvy4d4yg7mcvrcgwb2546wcix0n";
      };
    }
  );

}
