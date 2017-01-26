{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "neofetch-${version}";
  version = "3.0";
  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "0z8sqbspf6j7yqy7wbd8ba3pfn836b0y8kmgkcyvswgjkcyh8m68";
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
