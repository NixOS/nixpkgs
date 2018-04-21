{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  name = "neofetch-${version}";
  version = "3.4.0";
  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "10h4f7n6bllbq459nm9wppvk65n81zzv556njfqplzw3mpdrbiyx";
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
