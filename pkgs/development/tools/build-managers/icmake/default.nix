{ stdenv, fetchFromGitHub, gcc }:

stdenv.mkDerivation rec {
  name = "icmake-${version}";
  version = "9.02.04";

  src = fetchFromGitHub {
    sha256 = "0dkqdm7nc3l9kgwkkf545hfbxj7ibkxl7n49wz9m1rcq9pvpmrw3";
    rev = version;
    repo = "icmake";
    owner = "fbb-git";
  };


  setSourceRoot = ''
    sourceRoot=$(echo */icmake)
  '';

  buildInputs = [ gcc ];

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
