{ pkgs }:
self: super: {

  rmfuse = super.rmfuse.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/rschroll/rmfuse.git";
        rev = "3796b8610c8a965a60a417fc0bf8ea5200b71fd2";
        sha256 = "03qxy95jpk741b81bd38y51d4a0vynx2y1g662bci9r6m7l14yav";
      };
    }
  );

}
