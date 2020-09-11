{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jdupes";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "jbruchon";
    repo  = "jdupes";
    rev   = "v${version}";
    sha256 = "1gaqdcz0s31qncar9dzlr8izv50zlk4y6dgdm9xjk6as2g8b0fkk";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The testdir
    # directories have such files and will be removed.
    extraPostFetch = "rm -r $out/testdir";
  };

  dontConfigure = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    "ENABLE_DEDUPE=1"
    "STATIC_DEDUPE_H=1"
  ] ++ stdenv.lib.optionals stdenv.cc.isGNU [
    "HARDEN=1"
  ];

  enableParallelBuilding = true;

  doCheck = false; # broken Makefile, the above also removes tests

  postInstall = ''
    install -Dm444 -t $out/share/doc/jdupes CHANGES LICENSE README.md
  '';

  meta = with stdenv.lib; {
    description = "A powerful duplicate file finder and an enhanced fork of 'fdupes'";
    longDescription = ''
      jdupes is a program for identifying and taking actions upon
      duplicate files. This fork known as 'jdupes' is heavily modified
      from and improved over the original.
    '';
    homepage = "https://github.com/jbruchon/jdupes";
    license = licenses.mit;
    maintainers = with maintainers; [ romildo ];
  };
}
