{ lib, stdenv, fetchFromSourcehut, port ? "1234" }:

stdenv.mkDerivation {
  pname = "among-sus-unstable";
  version = "2020-10-29";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "among-sus";
    rev = "1f4c8d800d025d36ac66826937161be3252fbc57";
    sha256 = "19jq7ygh9l11dl1h6702bg57m04y35nqd6yqx1rgp1kxwhp45xyh";
  };

  patchPhase = ''
    sed -i 's/port = 1234/port = ${port}/g' main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 among-sus $out/bin
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~martijnbraam/among-sus";
    description = "Among us, but it's a text adventure";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.eyjhb ];
    platforms = platforms.unix;
  };
}
