{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "q60";
    repo = "disfetch";
    rev = version;
    sha256 = "sha256-xzOE+Pnx0qb3B9vWWrF5Q0nhUo0QYBUO6j6al8N3deY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin disfetch
    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet another *nix distro fetching program, but less complex";
    homepage = "https://github.com/q60/disfetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vel ];
    mainProgram = "disfetch";
  };
}
