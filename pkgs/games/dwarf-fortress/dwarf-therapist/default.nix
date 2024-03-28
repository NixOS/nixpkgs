{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qtdeclarative
, cmake
, texlive
, ninja
}:

stdenv.mkDerivation rec {
  pname = "dwarf-therapist";
  version = "42.1.5";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "sha256-aUakfUjnIZWNDhCkG3A6u7BaaCG8kPMV/Fu2S73CoDg=";
  };

  nativeBuildInputs = [ texlive cmake ninja ];
  buildInputs = [ qtbase qtdeclarative ];

  installPhase =
    if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      cp -r DwarfTherapist.app $out/Applications
    '' else null;

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Tool to manage dwarves in a running game of Dwarf Fortress";
    mainProgram = "dwarftherapist";
    maintainers = with maintainers; [ abbradar bendlas numinit jonringer ];
    license = licenses.mit;
    platforms = platforms.x86;
    homepage = "https://github.com/Dwarf-Therapist/Dwarf-Therapist";
  };
}
