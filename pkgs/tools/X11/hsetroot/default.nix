{ lib, stdenv
, fetchFromGitHub
, pkg-config
, imlib2
, libX11
, libXinerama
}:

stdenv.mkDerivation rec {
  pname = "hsetroot";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "himdel";
    repo = "hsetroot";
    rev = version;
    sha256 = "1jbk5hlxm48zmjzkaq5946s58rqwg1v1ds2sdyd2ba029hmvr722";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    imlib2
    libX11
    libXinerama
  ];

  postPatch = lib.optionalString (!stdenv.cc.isGNU) ''
    sed -i -e '/--no-as-needed/d' Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  meta = with lib; {
    description = "Allows you to compose wallpapers ('root pixmaps') for X";
    homepage = "https://github.com/himdel/hsetroot";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.unix;
  };
}
