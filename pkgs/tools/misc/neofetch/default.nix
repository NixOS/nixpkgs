{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "neofetch-${version}";
  version = "2.0.2";
  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "15fpm6nflf6w0c758xizfifvvxrkmcc2hpzrnfw6fcngfqcvajmd";
  };

  patchPhase = ''
    substituteInPlace ./neofetch \
    --replace "/usr/share" "$out/share"
  '';

  dontBuild = true;


  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with stdenv.lib; {
    description = "A fast, highly customizable system info script";
    homepage = https://github.com/dylanaraps/neofetch;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ alibabzo ];
  };
}
