{ stdenv, fetchFromGitHub, cmake, libusb1, ncurses5 }:

stdenv.mkDerivation rec {
  pname = "lguf-brightness";

  version = "unstable-2018-02-07";

  src = fetchFromGitHub  {
    owner = "periklis";
    repo = pname;
    rev = "d194272b7a0374b27f036cbc1a9be7f231d40cbb";
    sha256 = "0zj81bqchms9m7rik1jxp6zylh9dxqzr7krlj9947v0phr4qgah4";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libusb1 ncurses5 ];

  installPhase = ''
    install -D lguf_brightness $out/bin/lguf_brightness
  '';

  meta = with stdenv.lib; {
    description = "Adjust brightness for LG UltraFine 4K display (cross platform)";
    homepage = https://github.com/periklis/lguf-brightness;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ periklis ];
    platforms = with platforms; linux ++ darwin;
  };
}
