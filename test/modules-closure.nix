# Given a kernel build (with modules in $kernel/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{stdenv, kernel, rootModules, module_init_tools}:

stdenv.mkDerivation {
  name = kernel.name + "-shrunk";
  builder = ./modules-closure.sh;
  inherit kernel rootModules module_init_tools;
  allowedReferences = ["out"];
}
