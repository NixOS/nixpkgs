{ lib, rustPlatform, fetchFromGitHub, pkg-config, libX11, libXcursor, libxcb, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "xcolor";
  version = "unstable-2021-02-02";

  src = fetchFromGitHub {
    owner = "Soft";
    repo = pname;
    rev = "0e99e67cd37000bf563aa1e89faae796ec25f163";
    sha256 = "sha256-rHqK05dN5lrvDNbRCWGghI7KJwWzNCuRDEThEeMzmio=";
  };

  cargoSha256 = "sha256-lHOT/P1Sh1b53EkPIQM3l9Tozdqh60qlUDdjthj32jM=";

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libX11 libXcursor libxcb ];

  meta = with lib; {
    description = "Lightweight color picker for X11";
    homepage = "https://github.com/Soft/xcolor";
    maintainers = with lib.maintainers; [ fortuneteller2k ];
    license = licenses.mit;
  };
}
