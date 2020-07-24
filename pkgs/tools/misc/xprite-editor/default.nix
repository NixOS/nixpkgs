{ stdenv
, fetchFromGitHub
, rustPlatform
, gtk3
, AppKit
, pkg-config
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "xprite-editor-unstable";
  version = "2019-09-22";

  src = fetchFromGitHub {
    owner = "rickyhan";
    repo = "xprite-editor";
    rev = "7f899dff982642927024540e4bafd74e4ea5e52a";
    sha256 = "1k6k8y8gg1vdmyjz27q689q9rliw0rrnzwlpjcd4vlc6swaq9ahx";
    fetchSubmodules = true;
    # Rename unicode file name which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalization.
    postFetch = ''
      mv $out/config/palettes/Sweet\ Guaran*.hex $out/config/palettes/Sweet\ Guarana.hex
    '';
  };

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ gtk3 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit ];

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config python3 ];

  cargoSha256 = "1a0zy8gfc1gdk8nnv5qr4yspqy1jsip5nql3w74rl6h46cplpf5y";

  cargoBuildFlags = [ "--bin" "xprite-native" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/rickyhan/xprite-editor";
    description = "Pixel art editor";
    license = licenses.gpl3;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
