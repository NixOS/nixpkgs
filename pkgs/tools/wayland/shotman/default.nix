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
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BWHQtaDnM6lBEMkD8Y7M2NrWD78rY3yL8dzsa6PBiR0=";
  };

  cargoHash = "sha256-uckdpzCD3ItUVvpF2fHofcZFkQZzt8Xz/VWFiQ9Hkrs=";

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
    maintainers = with maintainers; [ zendo ];
  };
}
