{ lib, fetchCrate, rustPlatform, pkg-config, libXrandr, libX11, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "hacksaw";
  version = "1.0.4";

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libXrandr libX11 ];

  src = fetchCrate {
    inherit pname version;
    sha256 = "1l6i91xb81p1li1j2jm0r2rx8dbzl2yh468cl3dw0lqpqy4i65hx";
  };

  cargoSha256 = "14i4x5pl22b9cn41p8cmjl599brs7l8qkyhj3xifzj4nhax80s2p";

  meta = with lib; {
    description = "Lightweight selection tool for usage in screenshot scripts etc";
    homepage = "https://github.com/neXromancers/hacksaw";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ TethysSvensson ];
    platforms = platforms.linux;
  };
}
