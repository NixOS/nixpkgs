{ lib, stdenv, fetchFromGitHub, makeWrapper, perl, wdiff }:

stdenv.mkDerivation rec {
  version = "1.7.2";
  pname = "pkgdiff";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "pkgdiff";
    rev = version;
    sha256 = "1ahknyx0s54frbd3gqh070lkv3j1b344jrs6m6p1s1lgwbd70vnb";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/pkgdiff --prefix PATH : ${lib.makeBinPath [ wdiff ]}
  '';

  meta = with stdenv.lib; {
    description = "A tool for visualizing changes in Linux software packages";
    homepage = "https://lvc.github.io/pkgdiff/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sweber ];
    platforms = platforms.unix;
  };
}
