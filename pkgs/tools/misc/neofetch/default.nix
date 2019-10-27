{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "neofetch";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "022xzn9jk18k2f4b6011d8jk5nbl84i3mw3inlz4q52p2hvk8fch";
  };

  dontBuild = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  meta = with stdenv.lib; {
    description = "A fast, highly customizable system info script";
    homepage = https://github.com/dylanaraps/neofetch;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ alibabzo konimex ];
  };
}
