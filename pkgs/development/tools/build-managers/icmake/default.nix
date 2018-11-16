{ stdenv, fetchFromGitLab, makeWrapper, gcc, ncurses }:

stdenv.mkDerivation rec {
  name = "icmake-${version}";
  version = "9.02.08";

  src = fetchFromGitLab {
    sha256 = "1pr5lagmdls3clzwa2xwcfa3k5750rf7i0j3zld0xirb41zx07q2";
    rev = version;
    repo = "icmake";
    owner = "fbb-git";
  };


  setSourceRoot = ''
    sourceRoot=$(echo */icmake)
  '';

  nativeBuildInputs = [ makeWrapper ];
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

    wrapProgram $out/bin/icmbuild \
     --prefix PATH : ${ncurses}/bin
  '';

  meta = with stdenv.lib; {
    description = "A program maintenance (make) utility using a C-like grammar";
    homepage = https://fbb-git.gitlab.io/icmake/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
