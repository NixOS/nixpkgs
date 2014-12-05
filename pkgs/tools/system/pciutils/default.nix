{ stdenv, fetchurl, pkgconfig, zlib, kmod, which }:

let
  pciids = fetchurl {
    # Obtained from http://pciids.sourceforge.net/v2.2/pci.ids.bz2.
    url = http://tarballs.nixos.org/pci.ids.20131006.bz2;
    sha256 = "1vmshcgxqminiyh52pdcak24lm24qlic49py9cmkp96y1s48lvsc";
  };
in
stdenv.mkDerivation rec {
  name = "pciutils-3.3.0"; # with database from 2014-11-10

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "008kh33kbpkk1wr9srrapw93imqx7l4djglrdkfxwvy6ppa9acs1";
  };

  buildInputs = [ pkgconfig zlib kmod which ];

  #preBuild = "bunzip2 < ${pciids} > pci.ids";

  makeFlags = "SHARED=yes PREFIX=\${out}";

  installTargets = "install install-lib";

  # Get rid of update-pciids as it won't work.
  postInstall = "rm $out/sbin/update-pciids $out/man/man8/update-pciids.8";

  meta = with stdenv.lib; {
    homepage = http://mj.ucw.cz/pciutils.html;
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ]; # not really, but someone should watch it
  };
}

