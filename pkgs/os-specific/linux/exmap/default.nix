{ fetchurl, stdenv, kernel, pkgconfig, gtkmm, boost, pcre }:

stdenv.mkDerivation rec {
  name = "exmap-0.10-${kernel.version}";

  src = fetchurl {
    url = "http://www.berthels.co.uk/exmap/download/${name}.tgz";
    sha256 = "0z00dhl6bdmaz7p9wlvnj0izf0zlrlkv34fz449kxyislpzzxmgn";
  };

  patchPhase = ''
    substituteInPlace "kernel/Makefile" \
      --replace '/lib/modules/$(shell uname -r)/build' \
                ${kernel}/lib/modules/*/build

    # The `proc_root' variable (the root of `/proc') is no longer exported
    # since 2.6.26.  Fortunately, one can pass `NULL' instead of `&proc_root'.
    # See http://lkml.org/lkml/2008/3/30/57 .
    substituteInPlace "kernel/exmap.c" \
      --replace "&proc_root" "NULL"

    substituteInPlace "src/Makefile" --replace "-Werror" ""
  '';

  buildInputs = [ kernel pkgconfig gtkmm boost pcre ];

  buildPhase = "make build";

  # XXX: The tests can only be run one the `exmap' module is loaded.
  doCheck = false;
  #checkPhase = "make test"

  installPhase = ''
    ensureDir "$out/share/${name}"
    cp kernel/*.ko "$out/share/${name}"

    ensureDir "$out/bin"
    cp src/{gexmap,exmtool,elftool,showproc} "$out/bin"
  '';

  meta = {
    description = "Exmap, a tool showing the physical memory usage of processes";

    longDescription = ''
      Exmap is a utility which takes a snapshot of how the physical
      memory and swap space are currently used by all the processes on
      your system.  It examines which page of memory are shared between
      which processes, so that it can share the cost of the pages
      fairly when calculating usage totals.
    '';

    homepage = http://www.berthels.co.uk/exmap/;

    license = "GPLv2+";
  };
}
