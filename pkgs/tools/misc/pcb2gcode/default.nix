{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, boost
, glibmm
, gtkmm2
, gerbv
, librsvg
, bash
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "pcb2gcode";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "pcb2gcode";
    repo = "pcb2gcode";
    rev = "v${version}";
    sha256 = "sha256-3VQlYtSi6yWWNuxTlBzvBtkM5hAss47xat+sEW+P79E=";
  };

  patches = [
    # the patch below is part of upstream mainline, we can remove this
    # when they make their next release
    (fetchpatch {
      url = "https://github.com/pcb2gcode/pcb2gcode/commit/01cd18a6d859ab1aac6c532c99be9109f083448d.patch";
      sha256 = "sha256-5hl8KsDxSWMzXS3oRG0fBfHFq0IpZ//sU8lfY9Yp8L0=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ boost glibmm gtkmm2 gerbv librsvg ];

  postPatch = ''
    substituteInPlace ./Makefile.am \
    --replace '`git describe --dirty --always --tags`' '${version}'
  '';

  meta = with lib; {
    description = "Command-line tool for isolation, routing and drilling of PCBs ";
    longDescription = ''
      pcb2gcode is a command-line software for the isolation, routing and drilling of PCBs.
      It takes Gerber files as input and it outputs gcode files, suitable for the milling of PCBs.
      It also includes an Autoleveller, useful for the automatic dynamic calibration of the milling depth.
    '';
    homepage = "https://github.com/pcb2gcode/pcb2gcode";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kritnich ];
    platforms = platforms.unix;
  };
}
