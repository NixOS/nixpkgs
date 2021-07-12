{ lib, stdenv, fetchurl, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  version = "6.5.0";
  pname = "multitail";

  src = fetchurl {
    url = "https://www.vanheusden.com/multitail/${pname}-${version}.tgz";
    sha256 = "1vd9vdxyxsccl64ilx542ya5vlw2bpg6gnkq1x8cfqy6vxvmx7dj";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ];

  makeFlags = lib.optionals stdenv.isDarwin [ "-f" "makefile.macosx" ];

  installPhase = ''
    mkdir -p $out/bin
    cp multitail $out/bin
  '';

  meta = {
    homepage = "http://www.vanheusden.com/multitail/";
    description = "tail on Steroids";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
