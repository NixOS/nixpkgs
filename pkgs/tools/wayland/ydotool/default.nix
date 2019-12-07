{ stdenv, fetchFromGitHub, pkgconfig, cmake, boost, libevdevplus, libuinputplus }:

stdenv.mkDerivation rec {
  pname = "ydotool";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "ReimuNotMoe";
    repo = "ydotool";
    rev = "v${version}";
    sha256 = "0mx3636p0f8pznmwm4rlbwq7wrmjb2ygkf8b3a6ps96a7j1fw39l";
  };

  # disable static linking
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace \
      "-static" \
      ""
  '';

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    boost libevdevplus libuinputplus
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Generic Linux command-line automation tool";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = with platforms; linux;
  };
}
