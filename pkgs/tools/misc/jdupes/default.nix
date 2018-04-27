{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "jdupes-${version}";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "jbruchon";
    repo  = "jdupes";
    rev   = "v${version}";
    sha256 = "06y1njw8h64753r2cqb3vrs345bfj8dkls2fkj17hrw9gi8p1p0v";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The testdir
    # directories have such files and will be removed.
    extraPostFetch = "rm -r $out/testdir";
  };

  makeFlags = [ "PREFIX=$(out)" ] ++ stdenv.lib.optional stdenv.isLinux "ENABLE_BTRFS=1";

  meta = with stdenv.lib; {
    description = "A powerful duplicate file finder and an enhanced fork of 'fdupes'";
    longDescription = ''
      jdupes is a program for identifying and taking actions upon
      duplicate files. This fork known as 'jdupes' is heavily modified
      from and improved over the original.
    '';
    homepage = https://github.com/jbruchon/jdupes;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
