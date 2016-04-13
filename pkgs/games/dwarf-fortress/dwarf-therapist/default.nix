{ stdenv, fetchFromGitHub, coreutils, qtbase, qtdeclarative, texlive }:

let
  version = "37.0.0";
in
stdenv.mkDerivation {
  name = "dwarf-therapist-original-${version}";

  src = fetchFromGitHub {
    owner = "splintermind";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "0dw86b4x5hjhb7h4ynvwjgcinpqywfc5l48ljb5sahz08rfnx63d";
  };

  outputs = [ "out" "layouts" ];
  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ texlive ];

  enableParallelBuilding = false;

  configurePhase = ''
    qmake PREFIX=$out
  '';

  # Move layout files so they cannot be found by Therapist
  postInstall = ''
    mkdir -p $layouts
    mv $out/share/dwarftherapist/memory_layouts/* $layouts
    rmdir $out/share/dwarftherapist/memory_layouts
  '';

  meta = {
    description = "Tool to manage dwarves in in a running game of Dwarf Fortress";
    maintainers = with stdenv.lib.maintainers; [ the-kenny abbradar ];
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://github.com/splintermind/Dwarf-Therapist";
  };
}
