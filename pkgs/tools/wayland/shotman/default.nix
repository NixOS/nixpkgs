{ lib
, fetchFromSourcehut
, rustPlatform
, pkg-config
, libxkbcommon
, makeWrapper
, slurp
}:

rustPlatform.buildRustPackage rec {
  pname = "shotman";
  version = "0.4.5";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SctWNhYCFTAOOnDEcsFZH61+QQAcmup11GVVXA1U5Dw=";
  };

  cargoHash = "sha256-q5scdgfB5NgtjAgnIy/+c+y/mymF0b9ZZSz2LmM0pfw=";

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ libxkbcommon ];

  preFixup = ''
    wrapProgram $out/bin/shotman \
      --prefix PATH ":" "${lib.makeBinPath [ slurp ]}";
  '';

  meta = with lib; {
    description = "The uncompromising screenshot GUI for Wayland compositors";
    homepage = "https://git.sr.ht/~whynothugo/shotman";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo fpletz ];
  };
}
