{ stdenv, coreutils, fetchhg, qt4, dwarf_fortress, bash, makeWrapper }:

stdenv.mkDerivation rec {
  name = "dwarf-therapist-${rev}";
  rev = "eeeac8544d94";

  src = fetchhg {
    url = "https://code.google.com/r/splintermind-attributes/";
    tag = rev;
    sha256 = "0a9m967q6p2q3plrl6qysg1xrdmg65jzil6awjh2wr3g10x2x15z";
  };

  # Needed for hashing
  dwarfBinary = "${dwarf_fortress}/share/df_linux/libs/Dwarf_Fortress";

  buildInputs = [ coreutils qt4 dwarf_fortress makeWrapper ];
  enableParallelBuilding = false;

  preConfigure = ''
    substituteInPlace dwarftherapist.pro \
      --replace /usr/bin $out/bin     \
      --replace /usr/share $out/share \
      --replace "INSTALLS += doc" ""
  '';

  preBuild = ''
    # Log to current directory, otherwise it crashes if log/ doesn't
    # exist Note: Whis is broken because we cd to the nix store in the
    # wrapper-script
    substituteInPlace src/dwarftherapist.cpp \
      --replace "log/run.log" "dwarf-therapist.log"
  '';

  buildPhase = ''
    qmake INSTALL_PREFIX=$out;
    make;
  '';

  postInstall = ''
    # DwarfTherapist assumes it's run in $out/share/dwarftherapist and
    # therefore uses many relative paths.
    rm $out/bin/dwarftherapist
    wrapProgram $out/bin/DwarfTherapist \
      --run "cd $out/share/dwarftherapist"
  '';

  postFixup = ''
    # Fix checksum of memory access directives
    substituteInPlace $out/share/dwarftherapist/etc/memory_layouts/linux/v034.11.ini \
      --replace "e966ee88" $(md5sum ${dwarfBinary} | cut -c1-8)
  '';

  meta = {
    description = "Tool to manage dwarves in in a running game of Dwarf Fortress";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    license = "MIT";
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
    homepage = https://code.google.com/r/splintermind-attributes/;
  };
}
