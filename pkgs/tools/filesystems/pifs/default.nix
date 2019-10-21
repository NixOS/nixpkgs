{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, fuse }:

let
  version = "1.0";
in stdenv.mkDerivation {
  pname = "pifs";
  inherit version;

  src = fetchFromGitHub {
    owner = "philipl";
    repo = "pifs";
    rev = "3d9cc9db6a01234833c3d77c0846e20485763639";
    sha256 = "15xkq9xqpsmanm57xs0vvpl9c5v2g63ywp4gd8l6lkz4gsw3ailp";
  };

  preConfigure = ''
    export PKG_CONFIG=${pkgconfig}/bin/pkg-config
    export FUSE_CFLAGS="-I ${fuse}/include/fuse"
    export FUSE_LIBS="-L ${fuse}/lib -lfuse"
  '';

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  propagatedBuildInputs = [ fuse ];

  NIX_CFLAGS_COMPILE = ''
    -D_FILE_OFFSET_BITS=64
  '';

  meta = with stdenv.lib; {
    description = "Data-free filesystem";
    homepage = https://github.com/philipl/pifs ;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ chessai ];
    platforms = platforms.linux;
    inherit version;
  };
}
