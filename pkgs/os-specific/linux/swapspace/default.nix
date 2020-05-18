{ stdenv, fetchgit, autoconf, automake, utillinux, btrfs-progs }:

stdenv.mkDerivation rec {
  version = "1.16.1";
  name = "swapspace-${version}";

  src = fetchgit {
    url = "https://github.com/Tookmund/Swapspace.git";
    rev = "refs/tags/v${version}";
    sha256 = "1hbxaq05zdfhw5c8lypnl1qvh7n9ng0nawlizs9g6l77z8sn0ji8";
    fetchSubmodules = false;
  };

  # TODO patch runcommands to include path to mkswap, swapon/off, btrfs (optional)
  patchPhase = ''
    sed -e 's@"mkswap"@"${utillinux}/bin/mkswap"@' \
      -e 's@"/sbin/swapon"@"${utillinux}/bin/swapon"@' \
      -e 's@"/sbin/swapoff"@"${utillinux}/bin/swapoff"@' \
      -e 's@"btrfs"@"${btrfs-progs}/bin/btrfs"@' \
      -i src/support.c src/swaps.c
  '';

  enableParallelBuilding = true;

  buildInputs = [ autoconf automake ];

  preConfigure = ''
    autoreconf -i
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Tookmund/Swapspace/tree/v1.16.1";
    description =
      "Dynamically add and remove swapfiles based on memory pressure";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wmertens ];
    platforms = platforms.linux;
  };
}
