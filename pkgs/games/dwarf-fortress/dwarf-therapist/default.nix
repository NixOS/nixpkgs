{ stdenv, fetchFromGitHub, coreutils, qtbase, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-original-${version}";
  version = "37.0.0-Hello71";

  src = fetchFromGitHub {
    ## We use `Hello71`'s fork for 43.05 support
    # owner = "splintermind";
    owner = "Hello71";
    repo = "Dwarf-Therapist";
    rev = "42ccaa71f6077ebdd41543255a360c3470812b97";
    sha256 = "0f6mlfck7q31jl5cb6d6blf5sb7cigvvs2rn31k16xc93hsdgxaz";
  };

  outputs = [ "out" "layouts" ];
  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ texlive cmake ninja ];

  configurePhase = ''
    cmake -GNinja
  '';

  buildPhase = ''
    ninja -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./DwarfTherapist $out/bin/DwarfTherapist
    cp -r ./share/memory_layouts $layouts
  '';

  meta = with stdenv.lib; {
    description = "Tool to manage dwarves in in a running game of Dwarf Fortress";
    maintainers = with maintainers; [ the-kenny abbradar ];
    license = licenses.mit;
    platforms = platforms.linux;
    homepage = https://github.com/splintermind/Dwarf-Therapist;
  };
}
