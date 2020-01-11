{ stdenv, fetchFromGitHub, pkgconfig, ncurses, readline, pcsclite, qt5
, gcc-arm-embedded }:

let
  generic = { pname, version, rev, sha256 }:
    stdenv.mkDerivation rec {
      inherit pname version;

      src = fetchFromGitHub {
        owner = "Proxmark";
        repo = "proxmark3";
        inherit rev sha256;
      };

      nativeBuildInputs = [ pkgconfig gcc-arm-embedded ];
      buildInputs = [ ncurses readline pcsclite qt5.qtbase ];

      postPatch = ''
        substituteInPlace client/Makefile --replace '-ltermcap' ' '
        substituteInPlace liblua/Makefile --replace '-ltermcap' ' '
        substituteInPlace client/flasher.c \
          --replace 'armsrc/obj/fullimage.elf' \
                    '${placeholder "out"}/firmware/fullimage.elf'
      '';

      buildPhase = ''
        make bootrom/obj/bootrom.elf armsrc/obj/fullimage.elf client
      '';

      installPhase = ''
        install -Dt $out/bin client/proxmark3
        install -T client/flasher $out/bin/proxmark3-flasher
        install -Dt $out/firmware bootrom/obj/bootrom.elf armsrc/obj/fullimage.elf
      '';

      meta = with stdenv.lib; {
        description = "Client for proxmark3, powerful general purpose RFID tool";
        homepage = http://www.proxmark.org;
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [ fpletz ];
      };
    };
in

{
  proxmark3 = generic rec {
    pname = "proxmark3";
    version = "3.1.0";
    rev = "v${version}";
    sha256 = "1qw28n1bhhl91ix77lv50qcr919fq3hjc8zhhqphwxal2svgx2jf";
  };

  proxmark3-unstable = generic {
    pname = "proxmark3-unstable";
    version = "2019-12-28";
    rev = "a4ff62be63ca2a81071e9aa2b882bd3ff57f13ad";
    sha256 = "067lp28xqx61n3i2a2fy489r5frwxqrcfj8cpv3xdzi3gb3vk5c3";
  };
}
