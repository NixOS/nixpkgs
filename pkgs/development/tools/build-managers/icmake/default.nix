{ stdenv, fetchFromGitHub, gcc }:

stdenv.mkDerivation rec {
  name = "icmake-${version}";
  version = "9.02.02";

  src = fetchFromGitHub {
    sha256 = "0f7w3b8r2h6ckgzc6wbfbw5yyxia0f3j3acmzi1yzylj6ak05mmd";
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
