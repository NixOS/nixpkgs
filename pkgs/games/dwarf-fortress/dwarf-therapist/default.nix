{ stdenv, fetchFromGitHub, coreutils, qtbase, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-original-${version}";
  version = "39.1.2";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "0j5pldc184xv1mhdrhsmp23g58cy9a2bba27djigkh2sd5rksgji";
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
