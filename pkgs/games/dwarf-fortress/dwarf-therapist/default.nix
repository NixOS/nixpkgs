{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qtdeclarative
, cmake
, ninja
, version ? "42.1.6"
, hash ? "sha256-VjCXT4sl3HsFILrqTc3JJSeRedZaOXUbf4KvSzTo0uc="
}:

stdenv.mkDerivation rec {
  pname = "dwarf-therapist";

  inherit version;

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    inherit hash;
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ qtbase qtdeclarative ];

  enableParallelBuilding = true;

  cmakeFlags = [ "-GNinja" ];

  installPhase =
    if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      cp -r DwarfTherapist.app $out/Applications
    '' else null;

  dontWrapQtApps = true;

  meta = with lib; {
    mainProgram = "dwarftherapist";
    description = "Tool to manage dwarves in a running game of Dwarf Fortress";
    maintainers = with maintainers; [ abbradar bendlas numinit jonringer ];
    license = licenses.mit;
    platforms = platforms.x86;
    homepage = "https://github.com/Dwarf-Therapist/Dwarf-Therapist";
  };
}
