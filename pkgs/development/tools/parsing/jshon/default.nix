{ stdenv, lib, fetchFromGitHub, fetchpatch, jansson }:

stdenv.mkDerivation rec {
  name = "jshon-20160111.2";

  rev = "a61d7f2f85f4627bc3facdf951746f0fd62334b7";
  sha256 = "1053w7jbl90q3p5y34pi4i8an1ddsjzwaib5cfji75ivamc5wdmh";

  src = fetchFromGitHub {
    inherit rev sha256;
    owner = "keenerd";
    repo = "jshon";
  };

  patches = [
    # Fix null termination in read_stream.
    # https://github.com/keenerd/jshon/issues/53
    (fetchpatch {
      url = https://github.com/mbrock/jshon/commit/32288dd186573ceb58164f30be1782d4580466d8.patch;
      sha256 = "04rss2nprl9nqblc7smq0477n54hm801xgnnmvyzni313i1n6vhl";
    })
  ];

  buildInputs = [ jansson ];

  patchPhase =
    ''
      substituteInPlace Makefile --replace "/usr/" "/"
    '';

  preInstall =
    ''
      export DESTDIR=$out
    '';

  meta = with lib; {
    homepage = http://kmkeen.com/jshon;
    description = "JSON parser designed for maximum convenience within the shell";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ rushmorem ];
  };
}
