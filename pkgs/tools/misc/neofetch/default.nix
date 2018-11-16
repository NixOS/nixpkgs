{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "neofetch-${version}";
  version = "5.0.0";
  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "0yzyi2p0d8xp576lxyv5m9h60dl1d5dmrn40aad307872835b9rr";
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
