{ stdenvNoCC
, lib
, fetchFromGitHub
, nixosTests
, php
}:

stdenvNoCC.mkDerivation rec {
  pname = "FreshRSS";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "FreshRSS";
    rev = version;
    hash = "sha256-uidTsL8TREZ/qcqO/J+6hguP6Dr6J+995WNWCJCduBw=";
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
    runHook preInstall
    mkdir -p $out
    cp -vr * $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "FreshRSS is a free, self-hostable RSS aggregator";
    homepage = "https://www.freshrss.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ etu stunkymonkey ];
  };
}
