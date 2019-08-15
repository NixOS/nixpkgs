{ stdenv, fetchFromGitHub, which, libX11, libXt, fontconfig, freetype
, xorgproto ? null
, libXext ? null
, zlib ? null
, perl ? null  # For building web manuals
}:

stdenv.mkDerivation rec {
  pname = "plan9port";
  version = "2019-02-25";

  src =  fetchFromGitHub {
    owner = "9fans";
    repo = "plan9port";
    rev = "047fd921744f39a82a86d9370e03f7af511e6e84";
    sha256 = "1lp17948q7vpl8rc2bf5a45bc8jqyj0s3zffmks9r25ai42vgb43";
  };

  postPatch = ''
    #hardcoded path
    substituteInPlace src/cmd/acme/acme.c \
      --replace /lib/font/bit $out/plan9/font
    #deprecated flags
    find . -type f \
      -exec sed -i -e 's/_SVID_SOURCE/_DEFAULT_SOURCE/g' {} \; \
      -exec sed -i -e 's/_BSD_SOURCE/_DEFAULT_SOURCE/g' {} \;
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    #add missing ctrl+c\z\x\v keybind for non-Darwin
    substituteInPlace src/cmd/acme/text.c \
      --replace "case Kcmd+'c':" "case 0x03: case Kcmd+'c':" \
      --replace "case Kcmd+'z':" "case 0x1a: case Kcmd+'z':" \
      --replace "case Kcmd+'x':" "case 0x18: case Kcmd+'x':" \
      --replace "case Kcmd+'v':" "case 0x16: case Kcmd+'v':"
  '';

  buildInputs = [
    which perl libX11 fontconfig xorgproto libXt libXext
    freetype # fontsrv wants ft2build.h provides system fonts for acme and sam.
  ];

  builder = ./builder.sh;

  libX11_dev = libX11.dev;
  libXt_dev = libXt.dev;
  libXext_dev = libXext.dev;
  fontconfig_dev = fontconfig.dev;
  freetype_dev = freetype.dev;
  zlib_dev = zlib.dev;

  xorgproto_exp = xorgproto;
  libX11_exp = libX11;
  libXt_exp = libXt;
  libXext_exp = libXext;
  freetype_exp = freetype;
  zlib_exp = zlib;

  fontconfig_lib = fontconfig.lib;

  NIX_LDFLAGS="-lgcc_s";
  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/9 rc -c 'echo rc is working.'

    # 9l can find and use its libs
    cd $TMP
    cat >test.c <<EOF
    #include <u.h>
    #include <libc.h>
    #include <thread.h>
    void
    threadmain(int argc, char **argv)
    {
        threadexitsall(nil);
    }
    EOF
    $out/bin/9 9c -o test.o test.c
    $out/bin/9 9l -o test test.o
    ./test
  '';

  meta = with stdenv.lib; {
    homepage = https://9fans.github.io/plan9port/;
    description = "Plan 9 from User Space";
    longDescription = ''
      Plan 9 from User Space (aka plan9port) is a port of many Plan 9 programs
      from their native Plan 9 environment to Unix-like operating systems.
    '';
    license = licenses.lpl-102;
    maintainers = with maintainers; [ AndersonTorres bbarker
                                      ftrvxmtrx kovirobi ];
    platforms = platforms.unix;
  };
}
# TODO: investigate the mouse chording support patch
