{ lib, stdenv, fetchFromGitHub, meson, luajit, ninja, pkg-config
, python3, SDL2, lua, fftwFloat, zlib, bzip2, curl, darwin }:

stdenv.mkDerivation rec {
  pname = "the-powder-toy";
  version = "96.1.349";

  src = fetchFromGitHub {
    owner = "The-Powder-Toy";
    repo = "The-Powder-Toy";
    rev = "v${version}";
    sha256 = "sha256-MSN81kPaH8cWZO+QEOlMUQQghs1kn8CpsKA5SUC/RX8=";
  };

  nativeBuildInputs = [ meson ninja pkg-config python3 ];

  buildInputs = [ luajit SDL2 lua fftwFloat zlib bzip2 curl ];

  installPhase = ''
    install -Dm 755 powder $out/bin/powder
  '';

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A free 2D physics sandbox game";
    homepage = "http://powdertoy.co.uk/";
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar siraben ];
    mainProgram = "powder";
  };
}
