{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jdupes";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "jbruchon";
    repo  = "jdupes";
    rev   = "v${version}";
    sha256 = "1dzw1h9x9addkxf7r8lb8y09wmdkx8i61f5m96589r88jjk965xy";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The testdir
    # directories have such files and will be removed.
    extraPostFetch = "rm -r $out/testdir";
  };

  makeFlags = [ "PREFIX=$(out)" ] ++ stdenv.lib.optional stdenv.isLinux "ENABLE_BTRFS=1";

  enableParallelBuilding = true;

  doCheck = false; # broken Makefile, the above also removes tests

  postInstall = ''
    install -Dm644 -t $out/share/doc/jdupes CHANGES LICENSE README.md
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
