{ stdenv, fetchFromGitHub, liblaxjson, cmake, freeimage }:

stdenv.mkDerivation rec {
  version = "3.1.0";
  pname = "rucksack";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "rucksack";
    rev = "${version}";
    sha256 = "0bcm20hqxqnq1j0zghb9i7z9frri6bbf7rmrv5g8dd626sq07vyv";
  };

  buildInputs = [ cmake liblaxjson freeimage ];

  meta = with stdenv.lib; {
    description = "Texture packer and resource bundler";
    platforms = platforms.unix;
    homepage = https://github.com/andrewrk/rucksack;
    license = licenses.mit;
    maintainers = [ maintainers.andrewrk ];
  };
}
