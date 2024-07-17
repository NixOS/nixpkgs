{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  libXrandr,
  libX11,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "hacksaw";
  version = "1.0.4";

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    libXrandr
    libX11
  ];

  src = fetchCrate {
    inherit pname version;
    sha256 = "1l6i91xb81p1li1j2jm0r2rx8dbzl2yh468cl3dw0lqpqy4i65hx";
  };

  cargoSha256 = "1rykc06lq3bkblsrj68rbil63yqdnvxkxlppq1w74wf0d6cwjc08";

  meta = with lib; {
    description = "Lightweight selection tool for usage in screenshot scripts etc";
    homepage = "https://github.com/neXromancers/hacksaw";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ TethysSvensson ];
    platforms = platforms.linux;
    mainProgram = "hacksaw";
  };
}
