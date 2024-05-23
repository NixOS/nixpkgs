{ lib
, stdenv
, fetchFromSourcehut
, hare
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "himitsu";
  version = "0.7";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = version;
    hash = "sha256-jDxQajc8Kyfihm8q3wCpA+WsbAkQEZerLckLQXNhTa8=";
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
