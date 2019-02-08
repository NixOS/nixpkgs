{ stdenv, fetchFromGitHub, libcap, acl }:

stdenv.mkDerivation rec {
  name = "bfs-${version}";
  version = "1.3.2";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    sha256 = "0cyylqmq31if93zz0l1fnm454dsmcx34j4c2r0xprcggihdxbwk5";
  };

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ libcap acl ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "release" ]; # "release" enables compiler optimizations

  meta = with stdenv.lib; {
    description = "A breadth-first version of the UNIX find command";
    longDescription = ''
      bfs is a variant of the UNIX find command that operates breadth-first rather than
      depth-first. It is otherwise intended to be compatible with many versions of find.
    '';
    homepage = https://github.com/tavianator/bfs;
    license = licenses.bsd0;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yesbox ];
  };
}
