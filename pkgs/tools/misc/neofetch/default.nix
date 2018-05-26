{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  name = "neofetch-${version}";
  version = "4.0.2";
  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "0c0x05ca8lp74928nix4pvd243l95lav35r21mpkbagf72z284d2";
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
