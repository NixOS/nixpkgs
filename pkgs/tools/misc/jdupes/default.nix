{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "jdupes-${version}";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "jbruchon";
    repo  = "jdupes";
    rev   = "v${version}";
    sha256 = "1yg7071lwl561s7r0qrnfx45z3ny8gjfrxpx0dbyhv3ywiac5kw8";
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
