{ stdenv
, lib
, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "llathasa-veleth";
    repo = "disfetch";
    rev = version;
    sha256 = "sha256-9VPyH7tJEOKCB95VtoIZJ6pL2hEiKTXrp9C7HBD+oxc=";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin disfetch
  '';

  meta = with lib; {
    description = "Yet another *nix distro fetching program, but less complex";
    homepage = "https://github.com/llathasa-veleth/disfetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.vel ];
  };
}
