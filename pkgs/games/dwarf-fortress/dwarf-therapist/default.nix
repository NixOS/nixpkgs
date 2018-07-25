{ stdenv, fetchFromGitHub, qtbase
, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-${version}";
  version = "40.1.0";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "1aklwic5npgkp8rkrvz2q9idkipsm1h26mgd8q03135nzl1ld9q3";
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
