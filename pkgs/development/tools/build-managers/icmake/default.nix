{ stdenv, fetchFromGitHub, gcc5 }:

stdenv.mkDerivation rec {
  name = "icmake-${version}";
  version = "8.00.05";

  src = fetchFromGitHub {
    sha256 = "06bfz9awi2vh2mzikw4sp7wqrp0nlcg89b9br43awz2801k15hpf";
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
