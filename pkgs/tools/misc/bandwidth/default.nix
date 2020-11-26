{ stdenv, fetchurl, nasm }:

let
  inherit (stdenv.hostPlatform.parsed.cpu) bits;
  arch = "bandwidth${toString bits}";
in
stdenv.mkDerivation rec {
  pname = "bandwidth";
  version = "1.9.4";

  src = fetchurl {
    url = "https://zsmith.co/archives/${pname}-${version}.tar.gz";
    sha256 = "0x798xj3vhiwq2hal0vmf92sq4h7yalp3i6ylqwhnnpv99m2zws4";
  };

  postPatch = ''
    sed -i 's,^CC=gcc .*,,' OOC/Makefile Makefile*
    sed -i 's,ar ,$(AR) ,g' OOC/Makefile
  '';

  nativeBuildInputs = [ nasm ];

  buildFlags = [ arch ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${arch} $out/bin/bandwidth
  '';

  meta = with stdenv.lib; {
    homepage = "https://zsmith.co/bandwidth.html";
    description = "Artificial benchmark for identifying weaknesses in the memory subsystem";
    license = licenses.gpl2Plus;
    platforms = platforms.x86;
    maintainers = with maintainers; [ r-burns ];
  };
}
