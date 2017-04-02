{ stdenv, fetchFromGitHub, SDL }:

stdenv.mkDerivation rec {
  version = "0.15.1";
  name = "ja2-stracciatella-${version}";
  src = fetchFromGitHub {
    owner = "ja2-stracciatella";
    repo = "ja2-stracciatella";
    rev = "v${version}";
    sha256 = "0r7j6k7412b3qfb1rnh80s55zhnriw0v03zn5bp3spcqjxh4xhv1";
  };
  enableParallelBuilding = true;
  buildInputs = [ SDL ];
  meta = {
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = "https://ja2-stracciatella.github.io/";
  };
}
