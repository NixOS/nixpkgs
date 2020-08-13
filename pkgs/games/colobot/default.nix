{ SDL2
, SDL2_image
, SDL2_ttf
, boost
, cmake
, doxygen
, fetchFromGitHub
, fetchurl
, gettext
, glew
, libogg
, libpng
, librsvg
, libsndfile
, libvorbis
, openal
, perl
, physfs
, python27
, stdenv
, xmlstarlet
}:

stdenv.mkDerivation rec {
  pname = "colobot";
  version = "0.1.12-alpha";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "colobot-gold-${version}";
    sha256 = "1c181cclkrnspgs07lvndg2c81cjq3smkv7qim8c470cj88rcrp2";
    fetchSubmodules = true; # For data/ subdirectory.
  };

  # NOTE: There is a warning about missing po4a, but including it in the
  # build inputs causes compilation to fail. See nixpkgs issue #61035.
  # Thankfully, we can just exclude that package and it compiles fine.

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    librsvg
    perl
    python27
    xmlstarlet
  ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    boost
    glew
    libogg
    libpng
    libsndfile
    libvorbis
    openal
    physfs
  ];

  cmakeFlags = [ "-DCOLOBOT_INSTALL_BIN_DIR=${placeholder "out"}/bin" ];

  postPatch = let
    colobotMusic = fetchurl {
      url =
        "https://colobot.info/files/music/colobot-music_ogg_${version}.tar.gz";
      sha256 = "1s86cd36rwkff329mb1ay1wi5qqyi35564ppgr3f4qqz9wj9vs2m";
    };
  in ''
   # The installation process attempts to use wget to download music files
   # from https://colobot.info. To get around this, we remove the wget check
   # and instead populate the music directory ourselves:

   sed -i 's/find_program(WGET wget)//' \
            data/music/CMakeLists.txt
   tar -xvf ${colobotMusic} -Cdata/music
  '';

  meta = with stdenv.lib; {
    description = "Educational programming strategy game";
    longDescription = ''
      Colobot: Gold Edition is a real-time strategy game, where you can program
      your units (bots) in a language called CBOT, which is similar to C++ and
      Java.  Your mission is to find a new planet to live and survive. You can
      save humanity and get programming skills!
    '';
    homepage = "https://colobot.info/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wesnel ];
  };
}
