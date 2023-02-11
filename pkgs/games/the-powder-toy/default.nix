{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, SDL2
, bzip2
, curl
, fftwFloat
, lua
, luajit
, zlib
, Cocoa }:

stdenv.mkDerivation rec {
  pname = "the-powder-toy";
  version = "unstable-2022-08-30";

  src = fetchFromGitHub {
    owner = "The-Powder-Toy";
    repo = "The-Powder-Toy";
    rev = "9e712eba080e194fc162b475f58aaed8f4ea008e";
    sha256 = "sha256-44xUfif1E+T9jzixWgnBxOWmzPPuVZy7rf62ig/CczA=";
  };

  nativeBuildInputs = [ meson ninja pkg-config python3 ];

  buildInputs = [ SDL2 bzip2 curl fftwFloat lua luajit zlib ]
  ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  installPhase = ''
    install -Dm 755 powder $out/bin/powder

    mkdir -p $out/share/applications
    mv ../resources/powder.desktop $out/share/applications
    mv ../resources $out/share
  '';

  meta = with lib; {
    description = "A free 2D physics sandbox game";
    homepage = "https://powdertoy.co.uk/";
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar siraben ];
    mainProgram = "powder";
  };
}
