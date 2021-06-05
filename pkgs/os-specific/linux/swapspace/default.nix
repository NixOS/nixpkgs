{ stdenv, fetchgit, autoconf, automake, utillinux }:

stdenv.mkDerivation rec {
  version = "1.17";
  name = "swapspace-${version}";

  src = fetchgit {
    url = "https://github.com/Tookmund/Swapspace.git";
    rev = "refs/tags/v${version}";
    sha256 = "06xvmyy1fp94h00k9nn929j00ca3w12fiz07wf9az6srxa8i4ndz";
    fetchSubmodules = false;
  };

  patchPhase = ''
    sed -e 's@"mkswap"@"${utillinux}/bin/mkswap"@' \
      -e 's@"/sbin/swapon"@"${utillinux}/bin/swapon"@' \
      -e 's@"/sbin/swapoff"@"${utillinux}/bin/swapoff"@' \
      -i src/support.c src/swaps.c
  '';

  enableParallelBuilding = true;

  buildInputs = [ autoconf automake ];

  preConfigure = ''
    autoreconf -i
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Tookmund/Swapspace";
    description =
      "Dynamically add and remove swapfiles based on memory pressure";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wmertens ];
    platforms = platforms.linux;
  };
}
