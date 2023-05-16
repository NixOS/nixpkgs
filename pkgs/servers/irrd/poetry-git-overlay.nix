{ pkgs }:
self: super: {

  irrd = super.irrd.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/irrdnet/irrd.git";
        rev = "1f6cefbfc70802c67f4a8911c3f0bf2c1cf7e18a";
        sha256 = "1zmdqqv6vw8gdcwm67gc68lm224cipx6cdjf1dql61684s32g5wm";
      };
    }
  );

}
