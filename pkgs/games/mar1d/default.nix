{ stdenv
, fetchFromGitHub
, cmake
, mesa_glu
, x11
, xorg
, xinput_calibrator
, doxygen
, libpthreadstubs
, alsaLib
, alsaOss
, libao
, width ? 30
, mute ? false
, effects ? false
, sensitivity ? 5
, reverseY ? false
}:

stdenv.mkDerivation rec {
  name = "MAR1D-${version}";
  version = "0.2.0";
  options = "-w${toString width}"
          + " -s${toString sensitivity}"
          + (if mute then " -m" else "")
          + (if effects then " -f" else "")
          + (if reverseY then " -r" else "");

  src = fetchFromGitHub {
    sha256 = "152w5dnlxzv60cl24r5cmrj2q5ar0jiimrmxnp87kf4d2dpbnaq7";
    rev = "v${version}";
    repo = "fp_mario";
    owner = "olynch";
  };

  buildInputs =
    [
      alsaLib
      alsaOss
      cmake
      doxygen
      libao
      libpthreadstubs
      mesa_glu
      x11
      xinput_calibrator
      xorg.libXrandr
      xorg.libXi
      xorg.xinput
    ];

  preConfigure = ''
    cd src
  '';

  meta = with stdenv.lib; {
    description = "First person Super Mario Bros";
    longDescription = ''
      The original Super Mario Bros as you've never seen it. Step into Mario's
      shoes in this first person clone of the classic Mario game. True to the
      original, however, the game still takes place in a two dimensional world.
      You must view the world as mario does, as a one dimensional line.
    '';
    homepage = https://github.com/olynch/fp_mario;
    license = licenses.agpl3;
    maintainers = with maintainers; [ taeer ];
    platforms = platforms.linux;
  };
}
