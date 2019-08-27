{ stdenv, fetchurl, iasl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "nvramtool";
  version = "4.10";

  src = fetchurl {
    url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
    sha256 = "1jsiz17afi2lqg1jv6lsl8s05w7vr7iwgg86y2qp369hcz6kcwfa";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ iasl ];

  buildPhase = ''
    export LEX=${flex}/bin/flex
    make -C util/nvramtool
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp util/nvramtool/nvramtool $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Read/write coreboot parameters and display information from the coreboot table in CMOS/NVRAM";
    homepage = "https://www.coreboot.org/Nvramtool";
    license = licenses.gpl2;
    maintainers = [ maintainers.cryptix ];
    platforms = platforms.linux;
  };
}

