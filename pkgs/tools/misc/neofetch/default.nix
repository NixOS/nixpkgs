{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "neofetch";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "0i7wpisipwzk0j62pzaigbiq42y1mn4sbraz4my2jlz6ahwf00kv";
  };

  dontBuild = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    description = "A fast, highly customizable system info script";
    homepage = "https://github.com/dylanaraps/neofetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ alibabzo konimex ];
  };
}
