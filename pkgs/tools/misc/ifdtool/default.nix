{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ifdtool";
  version = "4.10";

  src = fetchurl {
    url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
    sha256 = "1jsiz17afi2lqg1jv6lsl8s05w7vr7iwgg86y2qp369hcz6kcwfa";
  };

  buildPhase = ''
    make -C util/ifdtool
    '';

  installPhase = ''
    install -Dm755 util/ifdtool/ifdtool $out/bin/ifdtool
    '';

  meta = with stdenv.lib; {
    description = "Extract and dump Intel Firmware Descriptor information";
    homepage = "https://www.coreboot.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.petabyteboy ];
    platforms = platforms.linux;
  };
}

