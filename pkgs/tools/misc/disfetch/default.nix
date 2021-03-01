{ stdenv
, lib
, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "llathasa-veleth";
    repo = "disfetch";
    rev = version;
    sha256 = "sha256-n1KfzxK1F1dji1/HG40vubNQ+R270+Ss0WCQivuVweE=";
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
