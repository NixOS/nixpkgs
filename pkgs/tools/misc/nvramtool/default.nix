{ stdenv, fetchgit, iasl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "nvramtool";
  version = "4.8.1";

  src = fetchgit {
    url = "http://review.coreboot.org/p/coreboot";
    rev = "refs/tags/${version}";
    sha256 = "0nrf840jg4fn38zcnz1r10w2yfpvrk1nvsrnbbgdbgkmpjxz0zw9";
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
    description = "utility for reading/writing coreboot parameters and displaying information from the coreboot table in CMOS/NVRAM";
    homepage = https://www.coreboot.org/Nvramtool;
    license = licenses.gpl2;
    maintainers = [ maintainers.cryptix ];
    platforms = platforms.linux;
  };
}

