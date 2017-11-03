{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  name = "neofetch-${version}";
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "1f1hvd635wv81qg802jdi0yggi4631w9nlznipaxkvk4y1zpdq5j";
  };

  dontBuild = true;


  makeFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc"
  ];

  meta = with stdenv.lib; {
    description = "A fast, highly customizable system info script";
    homepage = https://github.com/dylanaraps/neofetch;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ alibabzo konimex ];
  };
}
