{ lib, stdenv, fetchFromGitHub, meson, luajit, ninja, pkg-config
, python3, SDL2, lua, fftwFloat, zlib, bzip2, curl, darwin }:

stdenv.mkDerivation rec {
  pname = "the-powder-toy";
  version = "96.2.350";

  src = fetchFromGitHub {
    owner = "The-Powder-Toy";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "sha256-OAy/Hd2UksNiIfTdpA+u9NzIq1pfe8RYG3slI4/LNnM=";
  };

  nativeBuildInputs = [ meson ninja pkg-config python3 ];

  buildInputs = [ luajit SDL2 lua fftwFloat zlib bzip2 curl ];

  installPhase = ''
    install -Dm 755 powder $out/bin/powder

    mkdir -p $out/share/applications
    mv ../resources/powder.desktop $out/share/applications
    mv ../resources $out/share
  '';

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  meta = with lib; {
    description = "A free 2D physics sandbox game";
    homepage = "http://powdertoy.co.uk/";
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar siraben ];
    mainProgram = "powder";
  };
}
