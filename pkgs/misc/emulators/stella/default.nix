{ lib, stdenv, fetchFromGitHub, pkg-config, SDL2 }:

stdenv.mkDerivation rec {
  pname = "stella";
  version = "6.4";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = pname;
    rev = version;
    sha256 = "0gva6pw5c1pplcf2g48zmm24h1134v0vr705rbzj4v6ifp3adrsl";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL2 ];

  enableParallelBuilding = true;

  meta = with lib;{
    description = "An open-source Atari 2600 VCS emulator";
    longDescription = ''
    Stella is a multi-platform Atari 2600 VCS emulator released under
    the GNU General Public License (GPL). Stella was originally
    developed for Linux by Bradford W. Mott, and is currently
    maintained by Stephen Anthony.
    As of its 3.5 release, Stella is officially donationware.
    '';
    homepage = "https://stella-emu.github.io/";
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
