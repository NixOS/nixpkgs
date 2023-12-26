{ stdenvNoCC
, lib
, fetchFromGitHub
, nixosTests
, php
, pkgs
}:

stdenvNoCC.mkDerivation rec {
  pname = "FreshRSS";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "FreshRSS";
    rev = version;
    hash = "sha256-X7MYPn1OFmzMWGGlZZ67EHEaRJRKGrdnw6nCzuUfbgU=";
  };

  passthru.tests = {
    inherit (nixosTests) freshrss-sqlite freshrss-pgsql freshrss-http-auth;
  };

  buildInputs = [ php ];

  # There's nothing to build.
  dontBuild = true;

  postPatch = ''
    patchShebangs cli/*.php app/actualize_script.php
  '';

  installPhase = ''
    mkdir -p $out
    cp -vr * $out/
  '';

  meta = with lib; {
    description = "FreshRSS is a free, self-hostable RSS aggregator";
    homepage = "https://www.freshrss.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ etu stunkymonkey ];
  };
}
