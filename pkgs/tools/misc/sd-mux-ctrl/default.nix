{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  libftdi1,
  popt,
}:

stdenv.mkDerivation rec {
  pname = "sd-mux-ctrl-unstable";
  version = "2020-02-17";

  src = fetchgit {
    url = "https://git.tizen.org/cgit/tools/testlab/sd-mux";
    rev = "9dd189d973da64e033a0c5c2adb3d94b23153d94";
    sha256 = "0fxl8m1zkkyxkc2zi8930m0njfgnd04a22acny6vljnzag2shjvg";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libftdi1
    popt
  ];

  postInstall = ''
    install -D -m 644 ../doc/man/sd-mux-ctrl.1 $out/share/man/man1/sd-mux-ctrl.1
  '';

  meta = with lib; {
    description = "Tool for controlling multiple sd-mux devices";
    homepage = "https://wiki.tizen.org/SD_MUX";
    license = licenses.asl20;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.unix;
    mainProgram = "sd-mux-ctrl";
  };
}
