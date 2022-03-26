{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dockutil";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner  = "kcrawford";
    repo   = "dockutil";
    rev    = version;
    sha256 = "sha256-8tDkueCTCtvxc7owp3K9Tsrn4hL79CM04zBNv7AcHgA=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 scripts/dockutil -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool for managing dock items";
    homepage = "https://github.com/kcrawford/dockutil";
    license = licenses.asl20;
    maintainers = with maintainers; [ tboerger ];
    platforms = platforms.darwin;
  };
}
