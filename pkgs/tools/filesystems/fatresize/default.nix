{ stdenv, fetchurl, parted, substituteAll, utillinux }:

stdenv.mkDerivation rec {
  
  version = "1.0.2";
  name = "fatresize-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fatresize/fatresize-${version}.tar.bz2";
    sha256 = "04wp48jpdvq4nn0dgbw5za07g842rnxlh9mig4mslz70zqs0izjm";
  };
  
  buildInputs = [ parted utillinux ];
  
  # This patch helps this unmantained piece of software to be built against recent parted
  # It basically modifies the detection scheme for parted version (the current one has no micro version defined)
  # The second change is to include a header for a moved function since 1.6+ to current 3.1+ parted
  # The third change is to modify the call to PED_ASSERT that is no longer defined with 2 params
  patches = [ ./fatresize_parted_nix.patch ];
  
  preConfigure = ''
    echo "Replacing calls to ped_free with free ..."
    substituteInPlace ./fatresize.c --replace ped_free free
  '';
  
  # Filesystem resize functions were reintroduced in parted 3.1 due to no other available free alternatives
  # but in a sepparate library -> libparted-fs-resize --- that's why the added LDFLAG
  makeFlags = ''
    LDFLAGS=-lparted-fs-resize
  '';
  
  propagatedBuildInputs = [ parted utillinux ];
  
  meta = {
    description = "The FAT16/FAT32 non-destructive resizer";
    homepage = http://sourceforge.net/projects/fatresize;
    platforms = stdenv.lib.platforms.linux;
  };
}
