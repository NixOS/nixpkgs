{ pkgs }:
self: super: {

  rmfuse = super.rmfuse.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/rschroll/rmfuse.git";
        rev = "fca03bcdd6dc118f2ba981410ec9dff7f7cb88ec";
        sha256 = "0i7dvvi2bp3hydjpzvr7vg10bx0wxz87spf7pg455aga8d0qhxgk";
      };
    }
  );

}
