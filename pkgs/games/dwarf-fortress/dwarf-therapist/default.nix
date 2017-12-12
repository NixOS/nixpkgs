{ stdenv, fetchFromGitHub, coreutils, qtbase, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-original-${version}";
  version = "39.0.0";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "8ae293a6b45333bbf30644d11d1987651e53a307";
    sha256 = "0p1127agr2a97gp5chgdkaa0wf02hqgx82yid1cvqpyj8amal6yg";
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
