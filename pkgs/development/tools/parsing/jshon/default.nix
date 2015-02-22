{ stdenv, lib, fetchFromGitHub, jansson }:

stdenv.mkDerivation rec {
  name = "jshon-20140712";

  rev = "a61d7f2f85f4627bc3facdf951746f0fd62334b7";
  sha256 = "b0365e58553b9613a5636545c5bfd4ad05ab5024f192e1cb1d1824bae4e1a380";

  src = fetchFromGitHub {
    inherit rev sha256;
    owner = "keenerd";
    repo = "jshon";
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
    homepage = http://kmkeen.com/jshon;
    description = "JSON parser designed for maximum convenience within the shell.";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ rushmorem ];
  };
}
