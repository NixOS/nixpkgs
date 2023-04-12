{lib, stdenv, fetchurl, zlib}:

stdenv.mkDerivation rec {
  pname = "cramfsswap";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/cramfsswap/${pname}_${version}.tar.xz";
    sha256 = "10mj45zx71inaa3l1d81g64f7yn1xcprvq4v4yzpdwbxqmqaikw1";
  };
  #  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=996964
  patches = [ ./parallel-make.patch ];

  # Needed for cross-compilation
  postPatch = ''
    substituteInPlace Makefile --replace 'strip ' '$(STRIP) '
  '';

  buildInputs = [zlib];

  installPhase = ''
    install --target $out/bin -D cramfsswap
  '';

  meta = with lib; {
    description = "Swap endianess of a cram filesystem (cramfs)";
    homepage = "https://packages.debian.org/sid/utils/cramfsswap";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
