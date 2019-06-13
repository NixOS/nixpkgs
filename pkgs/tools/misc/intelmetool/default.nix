{ stdenv, fetchgit, zlib, pciutils }:

stdenv.mkDerivation rec {
  name = "intelmetool-${version}";
  version = "4.8.1";

  src = fetchgit {
    url = "https://review.coreboot.org/coreboot.git";
    rev = version;
    sha256 = "1gjisy9b7vgzjvy1fwaqhq3589yd59kkylv7apjmg5r2b3dv4zvr";
    fetchSubmodules = false;
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
    homepage = https://www.coreboot.org/Nvramtool;
    license = licenses.gpl2;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
