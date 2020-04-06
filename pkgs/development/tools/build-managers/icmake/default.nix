{ stdenv, fetchFromGitLab, makeWrapper, gcc, ncurses }:

stdenv.mkDerivation rec {
  pname = "icmake";
  version = "9.03.01";

  src = fetchFromGitLab {
    sha256 = "05r0a69w0hv2qhjpb2bxd0lmp2vv5r2d4iggg6ly4miam0i318jy";
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
