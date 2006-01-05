{stdenv, fetchurl, bash, gnused, coreutils, utillinux, gnugrep, module_init_tools}:

stdenv.mkDerivation {
  name = "hotplug-2004_03_29";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/linux-hotplug/hotplug-2004_03_29.tar.gz;
    md5 = "167bd479a1ca30243c51ca088e0942b3";
  };
  patches = [./hotplug-install-path.patch ./hotplug-install.patch ./hotplug-2004_03_29-bash.patch];
  inherit bash gnused coreutils utillinux gnugrep module_init_tools;
}
