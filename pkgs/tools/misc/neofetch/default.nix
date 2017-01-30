{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "neofetch-${version}";
  version = "3.0.1";
  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "0ccdgyn9m7vbrmjlsxdwv7cagsdg8hy8x4n1mx334pkqvl820jjn";
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
