{ stdenv, fetchFromGitHub, gcc }:

stdenv.mkDerivation rec {
  name = "icmake-${version}";
  version = "9.00.00";

  src = fetchFromGitHub {
    sha256 = "028rxx4ygy0z48m30m5pdach7kcp41swchhs8i15wag1mppllcy2";
    rev = version;
    repo = "icmake";
    owner = "fbb-git";
  };

  sourceRoot = "icmake-${version}-src/icmake";

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
