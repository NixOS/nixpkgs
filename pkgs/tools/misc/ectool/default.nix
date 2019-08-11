{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ectool";
  version = "4.10";

  src = fetchurl {
    url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
    sha256 = "1jsiz17afi2lqg1jv6lsl8s05w7vr7iwgg86y2qp369hcz6kcwfa";
  };

  buildPhase = ''
    make -C util/ectool
  '';

  installPhase = ''
    install -Dm755 util/ectool/ectool $out/bin/ectool
  '';

  meta = with stdenv.lib; {
    description = "Dump the RAM of a laptop's Embedded/Environmental Controller (EC)";
    homepage = "https://www.coreboot.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.petabyteboy ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

