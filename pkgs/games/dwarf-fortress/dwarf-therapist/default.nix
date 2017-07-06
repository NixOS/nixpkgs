{ stdenv, fetchFromGitHub, coreutils, qtbase, qtdeclarative, qmake, texlive }:

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
  nativeBuildInputs = [ texlive qmake ];

  enableParallelBuilding = false;

  # Move layout files so they cannot be found by Therapist
  postInstall = ''
    mkdir -p $layouts
    mv $out/share/dwarftherapist/memory_layouts/* $layouts
    rmdir $out/share/dwarftherapist/memory_layouts
    # Useless symlink
    rm $out/bin/dwarftherapist
  '';

  meta = with stdenv.lib; {
    description = "Tool to manage dwarves in in a running game of Dwarf Fortress";
    maintainers = with maintainers; [ the-kenny abbradar ];
    license = licenses.mit;
    platforms = platforms.linux;
    homepage = "https://github.com/splintermind/Dwarf-Therapist";
  };
}
