{ lib, rustPlatform, fetchFromGitHub, fetchpatch, pkg-config, libX11, libXcursor, libxcb, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "xcolor";
  version = "unstable-2021-02-02";

  src = fetchFromGitHub {
    owner = "Soft";
    repo = pname;
    rev = "0e99e67cd37000bf563aa1e89faae796ec25f163";
    sha256 = "sha256-rHqK05dN5lrvDNbRCWGghI7KJwWzNCuRDEThEeMzmio=";
  };

  cargoPatches = [
    # Update Cargo.lock, lexical_core doesn't build on Rust 1.52.1
    (fetchpatch {
      url = "https://github.com/Soft/xcolor/commit/324d80a18a39a11f2f7141b226f492e2a862d2ce.patch";
      sha256 = "sha256-5VzXitpl/gMef40UQBh1EoHezXPyB08aflqp0mSMAVI=";
    })
  ];

  cargoSha256 = "sha256-yD4pX+dCJvbDecsdB8tNt1VsEcyAJxNrB5WsZUhPGII=";

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libX11 libXcursor libxcb ];

  meta = with lib; {
    description = "Lightweight color picker for X11";
    homepage = "https://github.com/Soft/xcolor";
    maintainers = with lib.maintainers; [ fortuneteller2k ];
    license = licenses.mit;
  };
}
