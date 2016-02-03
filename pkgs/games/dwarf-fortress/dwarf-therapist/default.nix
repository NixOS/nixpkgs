{ stdenv, fetchFromGitHub, coreutils, qt4, texlive }:

let
  version = "36.0.0";
in
stdenv.mkDerivation {
  name = "dwarf-therapist-original-${version}";

  src = fetchFromGitHub {
    owner = "splintermind";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "08xjawb25sibkkfqwd4mlq73dgmgc6lxbbd673rx7yhrsjh4z4h3";
  };

  outputs = [ "out" "layouts" ];
  buildInputs = [ qt4 ];
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
    homepage = https://code.google.com/r/splintermind-attributes/;
  };
}
