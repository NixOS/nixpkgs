{ pkgs }:
self: super: {

  dmarc-metrics-exporter = super.dmarc-metrics-exporter.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/jgosmann/dmarc-metrics-exporter.git";
        rev = "3f1a0161d7ed51b9de48c056dcbc545b6375e872";
        sha256 = "18sndv32ig0xq7s42hvkdxbb9qxvycmnrawm3x22cp7zfidgfkh2";
      };
    }
  );

}
