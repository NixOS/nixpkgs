{ stdenvNoCC
, lib
, fetchFromGitHub
, nixosTests
, php
}:

stdenvNoCC.mkDerivation rec {
  pname = "FreshRSS";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "FreshRSS";
    rev = version;
    hash = "sha256-QMSSSSyInkWJP9im6RhyVItSgY30Nt2p1pRDdPPoaYI=";
  };

  passthru.tests = {
    inherit (nixosTests) freshrss-sqlite freshrss-pgsql freshrss-http-auth freshrss-none-auth;
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
