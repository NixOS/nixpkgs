{ lib
, stdenv
, fetchFromGitHub
, dos2unix
, edid-decode
, hexdump
, zsh
, modelines ? [ ] # Modeline "1280x800"   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync
, clean ? false # should it skip all, but explicitly listed modelines?
}:

# Usage:
#   (edid-generator.override {
#     clean = true;
#     modelines = [
#       ''Modeline "PG278Q_2560x1440"       241.50   2560 2608 2640 2720   1440 1443 1448 1481   -hsync +vsync''
#       ''Modeline "PG278Q_2560x1440@120"   497.75   2560 2608 2640 2720   1440 1443 1448 1525   +hsync -vsync''
#       ''Modeline "U2711_2560x1440"        241.50   2560 2600 2632 2720   1440 1443 1448 1481   -hsync +vsync''
#     ];
#   })

stdenv.mkDerivation rec {
  pname = "edid-generator";
  version = "unstable-2018-03-15";

  src = fetchFromGitHub {
    owner = "akatrevorjay";
    repo = "edid-generator";
    rev = "31a6f80784d289d2faa8c4ca4788409c83b3ea14";
    sha256 = "0j6wqzx5frca8b5i6812vvr5iwk7440fka70bmqn00k0vfhsc2x3";
  };

  nativeBuildInputs = [ dos2unix edid-decode hexdump zsh ];

  postPatch = ''
    patchShebangs modeline2edid
    # allows makefile to discover prefixes and suffixes in addition to just `[0-9]*x[0-9]*.S`
    awk -i inplace '/^SOURCES\t/ { print "SOURCES\t:= $(wildcard *[0-9]*x[0-9]**.S)"; next; }; { print; }' Makefile
  '';

  configurePhase = ''
    test '${toString clean}' != 1 || rm *x*.S
    ${lib.concatMapStringsSep "\n" (m: "./modeline2edid - <<<'${m}'") modelines}
    make clean all
  '';

  installPhase = ''
    install -Dm 444 *.bin -t "$out/lib/firmware/edid"
  '';

  meta = {
    description = "Hackerswork to generate an EDID blob from given Xorg Modelines";
    homepage = "https://github.com/akatrevorjay/edid-generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli nazarewk ];
    platforms = lib.platforms.all;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/edid-generator.x86_64-darwin
  };
}
