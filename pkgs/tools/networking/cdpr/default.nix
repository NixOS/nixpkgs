{ lib, stdenv, fetchurl, fetchpatch, libpcap }:

stdenv.mkDerivation rec {
  pname = "cdpr";
  version = "2.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}/${version}/${pname}-${version}.tgz";
    sha256 = "1idyvyafkk0ifcbi7mc65b60qia6hpsdb6s66j4ggqp7if6vblrj";
  };
  patches = [
    # Pull fix pending upstream inclusion for gcc-10 compatibility:
    #  https://sourceforge.net/p/cdpr/bugs/3/
    (fetchurl {
      name = "fno-common";
      url = "https://sourceforge.net/p/cdpr/bugs/3/attachment/0001-cdpr-fix-build-on-gcc-10-fno-common.patch";
      sha256 = "023cvkpc4ry1pbjd91kkwj4af3hia0layk3fp8q40vh6mbr14pnp";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace 'gcc' '"$$CC"'
  '';

  buildInputs = [ libpcap ];

  installPhase = ''
    install -Dm755 cdpr $out/bin/cdpr
  '';

  meta = with lib; {
    description = "Cisco Discovery Protocol Reporter";
    homepage = "http://cdpr.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.sgo ];
  };
}
