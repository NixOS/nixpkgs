{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qtdeclarative
, cmake
, texlive
, ninja
, isV50 ? true
}:

stdenv.mkDerivation rec {
  pname = "dwarf-therapist";

  # 41.2.5 is the last version to support Dwarf Fortress 0.47.
  version = if isV50 then "42.1.5" else "41.2.5";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    hash = if isV50 then # latest
      "sha256-aUakfUjnIZWNDhCkG3A6u7BaaCG8kPMV/Fu2S73CoDg="
    else # 41.2.5
      "sha256-xfYBtnO1n6OcliVt07GsQ9alDJIfWdVhtuyWwuvXSZs=";
  };

  nativeBuildInputs = [ texlive cmake ninja ];
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
