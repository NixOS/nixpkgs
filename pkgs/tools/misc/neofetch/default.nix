{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "neofetch";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "0xc0fdc7n5bhqirh83agqiy8r14l14zwca07czvj8vgnsnfybslr";
  };

  dontBuild = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  meta = with stdenv.lib; {
    description = "A fast, highly customizable system info script";
    homepage = "https://github.com/dylanaraps/neofetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ alibabzo konimex ];
  };
}
