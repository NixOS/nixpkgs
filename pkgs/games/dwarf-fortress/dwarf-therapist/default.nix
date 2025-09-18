{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qtdeclarative,
  cmake,
  ninja,
  dfVersions,

  # see: https://github.com/Dwarf-Therapist/Dwarf-Therapist/releases
  version ? dfVersions.therapist.version,
  maxDfVersion ? dfVersions.therapist.maxDfVersion,
  hash ? dfVersions.therapist.git.outputHash,
}:

stdenv.mkDerivation rec {
  pname = "dwarf-therapist";

  inherit version;

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    tag = "v${version}";
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
      bendlas
      numinit
    ];
    license = licenses.mit;
    platforms = platforms.x86;
    homepage = "https://github.com/Dwarf-Therapist/Dwarf-Therapist";
  };
}
