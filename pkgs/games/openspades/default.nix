{ lib, stdenv, fetchurl, fetchFromGitHub, fetchpatch, cmake, unzip, zip, file
, curl, glew , libGL, SDL2, SDL2_image, zlib, freetype, imagemagick
, openal , opusfile, libogg
, Cocoa, libXext
}:

stdenv.mkDerivation rec {
  pname = "openspades";
  version = "0.1.3";
  devPakVersion = "33";

  src = fetchFromGitHub {
    owner = "yvt";
    repo = "openspades";
    rev = "v${version}";
    sha256 = "1fvmqbif9fbipd0vphp57pk6blb4yp8xvqlc2ppipk5pjv6a3d2h";
  };

  nativeBuildInputs = [ cmake imagemagick unzip zip file ];

  buildInputs = [
    freetype SDL2 SDL2_image libGL zlib curl glew opusfile openal libogg libXext
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  notoFont = fetchurl {
    url = "https://github.com/yvt/openspades/releases/download/v0.1.1b/NotoFonts.pak";
    sha256 = "0kaz8j85wjjnf18z0lz69xr1z8makg30jn2dzdyicd1asrj0q1jm";
  };

  postPatch = ''
    sed -i 's,^wget .*,cp $devPak "$PAK_NAME",' Resources/downloadpak.sh
    patchShebangs Resources
  '';

  postInstall = ''
    cp $notoFont $out/share/games/openspades/Resources/
  '';

  NIX_CFLAGS_LINK = "-lopenal";

  meta = with lib; {
    description = "A compatible client of Ace of Spades 0.75";
    homepage    = "https://github.com/yvt/openspades/";
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ abbradar azahi ];
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isDarwin || (stdenv.isLinux && stdenv.isAarch64);
  };
}
