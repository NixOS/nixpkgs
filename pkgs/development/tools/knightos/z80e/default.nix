{ stdenv, fetchFromGitHub, cmake, knightos-scas, readline, SDL2 }:

stdenv.mkDerivation rec {
  pname = "z80e";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "z80e";
    rev = version;
    sha256 = "0gdv17ynjd6zf3i4hkimd89xkrd8kxas3bf8d5sq54fdicapvkzc";
  };

  nativeBuildInputs = [ cmake knightos-scas ];

  buildInputs = [ readline SDL2 ];

  cmakeFlags = [ "-Denable-sdl=YES" ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "A Z80 calculator emulator and debugger";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.unix;
  };
}
