{ stdenv, fetchFromGitHub, qtbase
, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  pname = "dwarf-therapist";
  version = "41.1.2";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "1qyyny2v4wxqs4ar02s8aawaxnkibz5aa5xgjm421k6v04iqxgcl";
  };

  nativeBuildInputs = [ texlive cmake ninja ];
  buildInputs = [ qtbase qtdeclarative ];

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -r DwarfTherapist.app $out/Applications
  '' else null;

  meta = with stdenv.lib; {
    description = "Tool to manage dwarves in a running game of Dwarf Fortress";
    maintainers = with maintainers; [ the-kenny abbradar bendlas numinit jonringer ];
    license = licenses.mit;
    platforms = platforms.unix;
    homepage = "https://github.com/Dwarf-Therapist/Dwarf-Therapist";
  };
}
