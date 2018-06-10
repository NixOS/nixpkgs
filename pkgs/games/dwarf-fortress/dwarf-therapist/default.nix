{ stdenv, fetchFromGitHub, coreutils, qtbase, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-original-${version}";
  version = "40.0.0";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "0b5y7800nzydn0jcc0vglgi9mzkj8f3qhw16wd872cf5396xnag9";
  };

  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ texlive cmake ninja ];

  meta = with stdenv.lib; {
    description = "Tool to manage dwarves in in a running game of Dwarf Fortress";
    maintainers = with maintainers; [ the-kenny abbradar bendlas ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    homepage = https://github.com/Dwarf-Therapist/Dwarf-Therapist;
  };
}
