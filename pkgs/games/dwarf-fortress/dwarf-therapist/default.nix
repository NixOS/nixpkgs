{ stdenv, fetchFromGitHub, qtbase
, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  pname = "dwarf-therapist";
  version = "41.1.3";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "15f6npbfgsxsr6pm2vxpali8f6nyyk80bcyhy9s77n064q0qg2nj";
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
