{ stdenv, lib, fetchFromGitHub, jansson }:

stdenv.mkDerivation rec {
  pname = "jshon";
  version = "20170302";

  src = fetchFromGitHub {
    owner = "keenerd";
    repo = "jshon";
    rev = "d919aeaece37962251dbe6c1ee50f0028a5c90e4";
    sha256 = "1x4zfmsjq0l2y994bxkhx3mn5vzjxxr39iib213zjchi9h6yxvnc";
  };

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
    homepage = "http://kmkeen.com/jshon";
    description = "JSON parser designed for maximum convenience within the shell";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ rushmorem ];
  };
}
