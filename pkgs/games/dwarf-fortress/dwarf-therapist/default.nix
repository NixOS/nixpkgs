{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qtdeclarative,
  cmake,
  ninja,
  # see: https://github.com/Dwarf-Therapist/Dwarf-Therapist/releases
  version ? "42.1.11",
  maxDfVersion ? "51.08",
  hash ? "sha256-uOQ6YdKjluQQyjtB0xsX7p7gCGuamkClKRR9h6FbQw8=",
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

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [
    qtbase
    qtdeclarative
  ];

  enableParallelBuilding = true;

  cmakeFlags = [ "-GNinja" ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        cp -r DwarfTherapist.app $out/Applications
      ''
    else
      null;

  dontWrapQtApps = true;

  passthru = {
    inherit maxDfVersion;
  };

  meta = with lib; {
    mainProgram = "dwarftherapist";
    description = "Tool to manage dwarves in a running game of Dwarf Fortress";
    maintainers = with maintainers; [
      abbradar
      bendlas
      numinit
    ];
    license = licenses.mit;
    platforms = platforms.x86;
    homepage = "https://github.com/Dwarf-Therapist/Dwarf-Therapist";
  };
}
