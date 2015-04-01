{ stdenv, coreutils, fetchgit, qt4, dwarf_fortress, bash, makeWrapper }:

let
  version = "30.2.0pre";
  df = dwarf_fortress;
in
stdenv.mkDerivation rec {
  name = "dwarf-therapist-${version}";

  src = fetchgit {
    url = "https://github.com/splintermind/Dwarf-Therapist.git";
    rev = "65bb15a29d616d788c20a3344058b7277e4fadba";
    sha256 = "1q1n9sm0lgmn52m4aigb22cdfbh2s569y1mn5cmimgj600i6c2f2";
  };

  # Needed for hashing
  dfHashFile = "${df}/share/df_linux/hash.md5";

  buildInputs = [ coreutils qt4 df makeWrapper ];
  enableParallelBuilding = false;

  configurePhase = ''
    qmake PREFIX=$out
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
