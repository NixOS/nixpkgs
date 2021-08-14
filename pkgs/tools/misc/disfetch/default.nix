{ stdenv
, lib
, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "q60";
    repo = "disfetch";
    rev = version;
    sha256 = "sha256-mjjFy6VItTg4VVXvGNjOJYHKHTy8o26iYsVC9Fq0YVg=";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin disfetch
  '';

  meta = with lib; {
    description = "Yet another *nix distro fetching program, but less complex";
    homepage = "https://github.com/q60/disfetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.vel ];
  };
}
