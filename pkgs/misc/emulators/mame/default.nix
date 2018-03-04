{ stdenv, fetchurl, asio, makeWrapper, pkgconfig, python3, glm, glibcLocales,
  lua5_3, SDL2, fontconfig, freetype, SDL2_ttf, sqlite, libjpeg,
  expat, flac, portaudio, portmidi, zlib, utf8proc, xorg,
  alsaSupport ? true, alsaLib,
  tools ? false,
  debug ? false, qtbase, #  to use mame's debugger you need qt on linux
  openglSupport ? true, mesa # -> mesa_noglu
}:

with stdenv.lib; stdenv.mkDerivation rec {
  version = "0.195";
  name    = "mame-${version}";
  mamename = "mame" + stdenv.lib.replaceStrings ["."] [""] (version);

  src = fetchurl {
      url    = "https://github.com/mamedev/mame/archive/${mamename}.tar.gz";
      sha256 = "0mwaq8afs0a1wcfk0acxmmg60g0bhly22w377b21icpnxhihx3di"; # 0195
    };

  #enableParallelBuilding = true;
  LC_ALL = "en_US.UTF-8";

  nativeBuildInputs = [ makeWrapper python3 pkgconfig ];
  buildInputs = [ asio lua5_3 glibcLocales SDL2 fontconfig freetype
        SDL2_ttf libjpeg expat flac portaudio portmidi sqlite utf8proc zlib ]
      ++ optionals openglSupport [ mesa glm ]
      ++ optionals alsaSupport [ alsaLib portmidi ]
      ++ optional debug [ qtbase ];

  #see scripts/target/mame/mess.lua
  sources="src/mame/drivers/amstrad.cpp";
           /*src/devices/imagedev/bitbngr.cpp,
           src/devices/bus/rs232/null_modem.cpp"; */
  subtarget = "amstrad";

  makeFlags = [

        "SOURCES=${sources}"
        "SUBTARGET=${subtarget}"

        # Disable using bundled libraries
        #"USE_SYSTEM_LIB_ASIO=1" # need  1.11.0
      	"USE_SYSTEM_LIB_EXPAT=1"
        "USE_SYSTEM_LIB_ZLIB=1"
        "USE_SYSTEM_LIB_JPEG=1"
      	"USE_SYSTEM_LIB_FLAC=1"
        "USE_SYSTEM_LIB_LUA=1" # need 5.3.4
      	"USE_SYSTEM_LIB_PORTAUDIO=1"
      	"USE_SYSTEM_LIB_SQLITE3=1"
        "USE_BUNDLED_LIB_SDL2=0" # error while loading shared libraries: libSDL2-2.0.so.0:
        "USE_SYSTEM_LIB_UTF8PROC=1"
        "USE_SYSTEM_LIB_GLM=1"
        #"USE_SYSTEM_LIB_RAPIDJSON=1" #broken on nixos

      	# Disable warnings being treated as errors and enable verbose build output
      	"NOWERROR=1"
      	"VERBOSE=1"

        "OPENMP=1"

        "REGENIE=1"
      ] ++ optional alsaSupport "USE_SYSTEM_LIB_PORTMIDI=1"
        ++ optional stdenv.is64bit "PTR64=1"
        ++ optional tools "TOOLS=1"
        ++ (if debug then [ "QT_HOME=${qtbase}" ] else [ "DEBUG=0" "USE_QTDEBUG=0" ]);
        #++ optional (!openglSupport) "USE_OPENGL=0";

      MAINBIN = (subtarget) + optionalString stdenv.is64bit "64" + optionalString debug "d";
      BINARIES = "castool chdman floptool imgtool jedutil ldresample ldverify nltool nlwav romcmp unidasm";

      installPhase = ''
        mkdir -p $out/{bin,/usr/share/mame,share/man/man6}
        cp $MAINBIN $out/usr/share/mame
        substitute ${./mame.sh} $out/bin/$MAINBIN \
            --subst-var MAINBIN \
            --subst-var out
        cp docs/man/*.6 $out/share/man/man6
        # docs ? remove *.po
        cp -a  uismall.bdf artwork bgfx ctrlr keymaps hash ini language nl_examples \
            plugins roms samples $out/usr/share/mame
        '' + optionalString tools ''
        mkdir -p $out/share/man/man1
        for f in $BINARIES ; do
          if [ -f $f ]
            then
              cp $f $out/bin
              #cp docs/man/$f.1 $out/share/man/man1
          fi
        done
        '';

      /* postInstall = ''
        $out/mame/$MAINBIN -noreadconfig -showconfig > $out/share/$name/$MAINBIN.ini
      ''; */

      meta = {
        homepage    = http://mamedev.org/;
        description = "Multiple Arcade Machine Emulator + Multi Emulator Super System (MESS)";
        longDescription = ''
        MAME's purpose is to preserve decades of software history. As electronic technology
        continues to rush forward, MAME prevents this important "vintage" software from being
        lost and forgotten. This is achieved by documenting the hardware and how it functions.
        The source code to MAME serves as this documentation. The fact that the software is
        usable serves primarily to validate the accuracy of the documentation
        (how else can you prove that you have recreated the hardware faithfully?).
        Over time, MAME (originally stood for Multiple Arcade Machine Emulator)
        absorbed the sister-project MESS (Multi Emulator Super System), so MAME now documents
        a wide variety of (mostly vintage) computers, video game consoles and calculators,
        in addition to the arcade video games that were its initial focus.
        '';
        license     = "MAME";
        maintainers = [ maintainers.genesis ];
        platforms   = platforms.linux; # should work on darwin with a little effort.
      };
}
