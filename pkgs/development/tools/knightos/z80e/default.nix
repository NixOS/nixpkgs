{ stdenv, fetchFromGitHub, cmake, knightos-scas, readline, SDL2 }:

stdenv.mkDerivation rec {
  pname = "z80e";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "z80e";
    rev = version;
    sha256 = "18nnip6nv1pq19bxgd07fv7ci3c5yj8d9cip97a4zsfab7bmbq6k";
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
