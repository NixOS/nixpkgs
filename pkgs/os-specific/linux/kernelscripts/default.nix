{stdenv, module_init_tools, kernel, modules}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  name = "kernelscripts-0.0.1";

  inherit module_init_tools kernel modules;
}
