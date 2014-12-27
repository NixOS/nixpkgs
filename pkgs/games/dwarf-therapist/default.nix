{ stdenv, coreutils, fetchurl, qt4, dwarf_fortress, bash, makeWrapper }:

let
  version = "30.1.0";
  df = dwarf_fortress;
in
stdenv.mkDerivation rec {
  name = "dwarf-therapist-${version}";

  src = fetchurl {
    url = "https://github.com/splintermind/Dwarf-Therapist/archive/v${version}.tar.gz";
    sha256 = "1x9dkis6b3f8iqcfrc2cj9mcgkwf0rzhxhq2lgy4xdr2n0yjkyv7";
  };

  # Needed for hashing
  dfHashFile = "${df}/share/df_linux/hash.md5";

  buildInputs = [ coreutils qt4 df makeWrapper ];
  enableParallelBuilding = false;

  configurePhase = ''
    substituteInPlace dwarftherapist.pro \
      --replace /usr/bin $out/bin     \
      --replace /usr/share $out/share \
      --replace "INSTALLS += doc" ""

    qmake INSTALL_PREFIX=$out
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
    substituteInPlace $out/share/dwarftherapist/memory_layouts/linux/v0${df.baseVersion}.${df.patchVersion}.ini \
      --replace $(cat "${dfHashFile}.orig") $(cat "${dfHashFile}.patched")
  '';

  meta = {
    description = "Tool to manage dwarves in in a running game of Dwarf Fortress";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
    homepage = https://code.google.com/r/splintermind-attributes/;
  };
} 
