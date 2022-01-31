{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "q60";
    repo = "disfetch";
    rev = version;
    sha256 = "sha256-pKjSEK0DuQf2rBkOtqRhfhnpEHMqvmXwzKrwKL/T3QU=";
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
  };
}
