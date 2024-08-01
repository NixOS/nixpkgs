{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, wxGTK32
, ffmpeg_4
, lua5_1
, curl
, libpng
, xorg
, pkg-config
, flam3
, libgtop
, boost179
, tinyxml
, libglut
, libGLU
, libGL
, glee
}:

stdenv.mkDerivation rec {
  pname = "electricsheep";
  version = "3.0.2-2019-10-05";

  src = fetchFromGitHub {
    owner = "scottdraves";
    repo = pname;
    rev = "37ba0fd692d6581f8fe009ed11c9650cd8174123";
    sha256 = "sha256-v/+2dxOY/p6wNAywcFHUAfsZEJw31Syu2MacN/KeyWg=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    wxGTK32
    ffmpeg_4
    lua5_1
    curl
    libpng
    xorg.libXrender
    flam3
    libgtop
    boost179
    tinyxml
    libglut
    libGLU
    libGL
    glee
  ];

  preAutoreconf = ''
    cd client_generic
    sed -i '/ACX_PTHREAD/d' configure.ac
  '';

  configureFlags = [
    "CPPFLAGS=-I${glee}/include/GL"
  ];

  makeFlags = [
    ''CXXFLAGS+="-DGL_GLEXT_PROTOTYPES"''
  ];

  preBuild = ''
    sed -i "s|/usr|$out|" Makefile
  '';

  meta = with lib; {
    description = "Electric Sheep, a distributed screen saver for evolving artificial organisms";
    homepage = "https://electricsheep.org/";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
