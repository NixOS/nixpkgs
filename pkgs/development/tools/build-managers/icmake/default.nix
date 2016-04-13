{ stdenv, fetchFromGitHub, gcc5 }:

stdenv.mkDerivation rec {
  name = "icmake-${version}";
  version = "8.01.00";

  src = fetchFromGitHub {
    sha256 = "1vgjywbc4w1agkakfndr2qf0z0ncxisihdv8sz9ipry9f170np39";
    rev = version;
    repo = "icmake";
    owner = "fbb-git";
  };

  sourceRoot = "icmake-${version}-src/icmake";

  buildInputs = [ gcc5 ];

  preConfigure = ''
    patchShebangs ./
    substituteInPlace INSTALL.im --replace "usr/" ""
  '';

  buildPhase = ''
    ./icm_prepare $out
    ./icm_bootstrap x
  '';

  installPhase = ''
    ./icm_install all /
  '';

  meta = with stdenv.lib; {
    description = "A program maintenance (make) utility using a C-like grammar";
    homepage = https://fbb-git.github.io/icmake/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ nckx pSub ];
    platforms = platforms.linux;
  };
}
