{ stdenv, fetchFromGitHub, qtbase
, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  pname = "dwarf-therapist";
  version = "41.1.5";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "0w1mwwf49vdmvmdfvlkn4m0hzvlj111rpl8hv4rw6v8nv6yfb2y4";
  };

  nativeBuildInputs = [ texlive cmake ninja ];
  buildInputs = [ qtbase qtdeclarative ];

  installPhase = if stdenv.isDarwin then ''
    local applications="$out/Applications"
    mkdir -p "$applications"

    local dt_app="$applications/DwarfTherapist.app"
    cp -r DwarfTherapist.app "$dt_app"

    local app_dir="$dt_app/Contents"
    local res_dir="$app_dir/Resources"

    local memory_layouts="$res_dir/memory_layouts"
    mkdir -p "$memory_layouts"
    cp -r ../share/memory_layouts/osx "$memory_layouts/"

    # Linux compatibility
    mkdir -p "$out/bin"
    ln -s "$app_dir/MacOS/DwarfTherapist" "$out/bin/dwarftherapist"
    mkdir -p "$out/share"
    ln -s "$res_dir" "$out/share/dwarftherapist"
  '' else null;

  meta = with stdenv.lib; {
    description = "Tool to manage dwarves in a running game of Dwarf Fortress";
    maintainers = with maintainers; [ abbradar bendlas numinit jonringer ];
    license = licenses.mit;
    platforms = platforms.unix;
    homepage = "https://github.com/Dwarf-Therapist/Dwarf-Therapist";
  };
}
