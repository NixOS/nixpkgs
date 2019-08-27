{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cbmem";
  version = "4.10";

  src = fetchurl {
    url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
    sha256 = "1jsiz17afi2lqg1jv6lsl8s05w7vr7iwgg86y2qp369hcz6kcwfa";
  };

  buildPhase = ''
    make -C util/cbmem
  '';

  installPhase = ''
    install -Dm755 util/cbmem/cbmem $out/bin/cbmem
  '';

  meta = with stdenv.lib; {
    description = "Read coreboot timestamps and console logs";
    homepage = "https://www.coreboot.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.petabyteboy ];
    platforms = platforms.linux;
  };
}

