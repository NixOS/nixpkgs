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
, jsoncpp
, libpng
, Cocoa }:

stdenv.mkDerivation rec {
  pname = "the-powder-toy";
  version = "97.0.352";

  src = fetchFromGitHub {
    owner = "The-Powder-Toy";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "sha256-LYohsqFU9LBgTXMaV6cf8/zf3fBvT+s5A1JBpPHekH8=";
  };

  nativeBuildInputs = [ meson ninja pkg-config python3 ];

  buildInputs = [ SDL2 bzip2 curl fftwFloat lua luajit zlib jsoncpp libpng ]
  ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  mesonFlags = [ "-Dworkaround_elusive_bzip2=false" ];

  installPhase = ''
    install -Dm 755 powder $out/bin/powder

    mkdir -p $out/share/applications
    mv ../resources $out/share
  '' + lib.optionalString stdenv.isLinux ''
    mv ./resources/powder.desktop $out/share/applications
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
