{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "outils";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xYjILa0Km57q/xNP+M34r29WLGC15tzUNoUgPzQTtIs=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/leahneukirchen/outils";
    description = "Port of OpenBSD-exclusive tools such as `calendar`, `vis`, and `signify`";
    license = with licenses; [
      beerware
      bsd2
      bsd3
      bsdOriginal
      isc
      mit
      publicDomain
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ somasis ];
  };
}
