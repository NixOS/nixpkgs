{ stdenv, fetchurl, zlib, pciutils }:

stdenv.mkDerivation rec {
  pname = "intelmetool";
  version = "4.10";

  src = fetchurl {
    url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
    sha256 = "1jsiz17afi2lqg1jv6lsl8s05w7vr7iwgg86y2qp369hcz6kcwfa";
  };

  buildInputs = [ zlib pciutils ];

  buildPhase = ''
    make -C util/intelmetool
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp util/intelmetool/intelmetool $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Dump interesting things about Management Engine";
    homepage = "https://www.coreboot.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
