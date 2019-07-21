{pkgs, lib}:
self: {
  # Don't pollute the namespace (for e.g. tab completion)
  inherit pkgs;

  # Thus we can take dependencies from both pkgs and Ghidra nevertheless.
  # Packages from ghidra take precedence on collision.
  callPackage = lib.callPackageWith ( self.pkgs // self );


  tracing = false;
  trace = str: val: 
    if self.tracing then
      lib.traceValFn (v: "${str}\n${lib.generators.toPretty {} v}") val
    else
      val;
  }
