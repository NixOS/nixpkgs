{ lib
, stdenv
, fetchFromSourcehut
, hare
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "himitsu";
  version = "0.1";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = "003c14747fcddceb5359c9503f20c44b15fea5fa";
    hash = "sha256-tzBTDJKMuFh9anURy1aKQTmt77tI7wZDZQiOUowuomk=";
  };

  nativeBuildInputs = [
    hare
    scdoc
  ];

  preConfigure = ''
    export HARECACHE=$(mktemp -d)
  '';

  installFlags = [ "PREFIX=" "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://himitsustore.org/";
    description = "A secret storage manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ auchter ];
    inherit (hare.meta) platforms badPlatforms;
  };
}
