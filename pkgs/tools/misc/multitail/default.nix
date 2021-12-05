{ lib, stdenv, fetchurl, fetchpatch, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  version = "6.5.0";
  pname = "multitail";

  src = fetchurl {
    url = "https://www.vanheusden.com/multitail/${pname}-${version}.tgz";
    sha256 = "1vd9vdxyxsccl64ilx542ya5vlw2bpg6gnkq1x8cfqy6vxvmx7dj";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3:
    #  https://github.com/halturin/multitail/pull/4
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url =
        "https://github.com/halturin/multitail/commit/d7d10f3bce261074c116eba9f924b61f43777662.patch";
      sha256 = "0kyp9l6v92mz6d3h34j11gs5kh3sf2nv76mygqfxb800vd8r0cgg";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ];

  makeFlags = lib.optionals stdenv.isDarwin [ "-f" "makefile.macosx" ];

  installPhase = ''
    mkdir -p $out/bin
    cp multitail $out/bin
  '';

  meta = {
    homepage = "https://github.com/halturin/multitail";
    description = "tail on Steroids";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
