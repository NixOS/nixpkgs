{ stdenv, fetchFromGitHub, qtbase
, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-${version}";
  version = "41.0.2";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "0cvnk1dkszh7q7viv3i1v3ifzv1w0xyz69mifa1cbvbi47z2dh0d";
  };

  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ texlive cmake ninja ];

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -r DwarfTherapist.app $out/Applications
  '' else null;

  meta = with stdenv.lib; {
    description = "Tool to manage dwarves in a running game of Dwarf Fortress";
    maintainers = with maintainers; [ the-kenny abbradar bendlas numinit ];
    license = licenses.mit;
    platforms = platforms.unix;
    homepage = https://github.com/Dwarf-Therapist/Dwarf-Therapist;
  };
}
