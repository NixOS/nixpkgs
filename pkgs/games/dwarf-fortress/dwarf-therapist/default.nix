{ stdenv, fetchFromGitHub, coreutils, qtbase, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-original-${version}";
  version = "39.2.1";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "1dgcn1a4sz649kj94ldqy4ms7zhwpaj3q4r86b0yfh6dda8jzlgp";
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
    maintainers = with maintainers; [ the-kenny abbradar bendlas ];
    license = licenses.mit;
    platforms = platforms.linux;
    homepage = https://github.com/Dwarf-Therapist/Dwarf-Therapist;
  };
}
