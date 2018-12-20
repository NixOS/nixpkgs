{ stdenv, fetchurl, fetchFromGitHub, fetchpatch, cmake, unzip, zip, file
, curl, glew , libGL, SDL2, SDL2_image, zlib, freetype, imagemagick
, openal , opusfile, libogg
, Cocoa
}:

stdenv.mkDerivation rec {
  name = "openspades-${version}";
  version = "0.1.2";
  devPakVersion = "33";

  src = fetchFromGitHub {
    owner = "yvt";
    repo = "openspades";
    rev = "v${version}";
    sha256 = "1mfj46c3pnn1f6awy3b6faxs26i93a5jsrvkdlr12ndsykvi6ng6";
  };

  nativeBuildInputs = [ cmake imagemagick unzip zip file ];

  buildInputs = [
    freetype SDL2 SDL2_image libGL zlib curl glew opusfile openal libogg
  ] ++ stdenv.lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
  ];

  patches = [
    # https://github.com/yvt/openspades/pull/793 fix Darwin build
    (fetchpatch {
      url = "https://github.com/yvt/openspades/commit/2d13704fefc475b279337e89057b117f711a35d4.diff";
      sha256 = "1i7rcpjzkjhbv5pp6byzrxv7sb1iamqq5k1vyqlvkbr38k2dz0rv";
    })
  ];

  cmakeFlags = [
    "-DOPENSPADES_INSTALL_BINARY=bin"
  ];

  devPak = fetchurl {
    url = "https://github.com/yvt/openspades-paks/releases/download/r${devPakVersion}/OpenSpadesDevPackage-r${devPakVersion}.zip";
    sha256 = "1bd2fyn7mlxa3xnsvzj08xjzw02baimqvmnix07blfhb78rdq9q9";
  };

  postPatch = ''
    sed -i 's,^wget .*,cp $devPak "$PAK_NAME",' Resources/downloadpak.sh
    patchShebangs Resources
  '';

  enableParallelBuilding = true;

  NIX_CFLAGS_LINK = [ "-lopenal" ];

  meta = with stdenv.lib; {
    description = "A compatible client of Ace of Spades 0.75";
    homepage    = "https://github.com/yvt/openspades/";
    license     = licenses.gpl3;
    platforms   = platforms.all;
  };
}
