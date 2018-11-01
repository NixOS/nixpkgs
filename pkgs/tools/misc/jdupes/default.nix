{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "jdupes-${version}";
  version = "1.10.4";

  src = fetchFromGitHub {
    owner = "jbruchon";
    repo  = "jdupes";
    rev   = "v${version}";
    sha256 = "03a2jxv634xy5qwjrk784k3y3pd8f94pndf5m84yg2y7i8dvppnk";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The testdir
    # directories have such files and will be removed.
    extraPostFetch = "rm -r $out/testdir";
  };

  makeFlags = [ "PREFIX=$(out)" ] ++ stdenv.lib.optional stdenv.isLinux "ENABLE_BTRFS=1";

  enableParallelBuilding = true;

  doCheck = false; # broken Makefile, the above also removes tests

  postInstall = ''
    install -Dm644 -t $out/share/doc/jdupes CHANGES LICENSE README
  '';

  meta = with stdenv.lib; {
    description = "A powerful duplicate file finder and an enhanced fork of 'fdupes'";
    longDescription = ''
      jdupes is a program for identifying and taking actions upon
      duplicate files. This fork known as 'jdupes' is heavily modified
      from and improved over the original.
    '';
    homepage = https://github.com/jbruchon/jdupes;
    license = licenses.mit;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.all;
  };
}
