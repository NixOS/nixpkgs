{ stdenv, fetchFromGitHub, coreutils, qtbase, qtdeclarative, qmakeHook, texlive }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-original-${version}";
  version = "37.0.0";

  src = fetchFromGitHub {
    owner = "splintermind";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "0dw86b4x5hjhb7h4ynvwjgcinpqywfc5l48ljb5sahz08rfnx63d";
  };

  outputs = [ "out" "layouts" ];
  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ texlive qmakeHook ];

  enableParallelBuilding = false;

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
