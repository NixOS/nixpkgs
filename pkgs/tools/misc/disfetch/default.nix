{ stdenv, lib, fetchFromGitHub, disfetch, testVersion }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "q60";
    repo = "disfetch";
    rev = version;
    sha256 = "sha256-1BxBeZfZK/vjUgTZknQLTLyWnI4LYyc1BmQeMcbwFP8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin disfetch
    runHook postInstall
  '';

  passthru.tests.version = testVersion { package = disfetch; };

  meta = with lib; {
    description = "Yet another *nix distro fetching program, but less complex";
    homepage = "https://github.com/q60/disfetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vel ];
  };
}
