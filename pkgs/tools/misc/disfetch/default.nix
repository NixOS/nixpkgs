{ stdenv
, lib
, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "llathasa-veleth";
    repo = "disfetch";
    rev = version;
    sha256 = "0p5pj8d761gz95ar35s8q6lrybrg9jik33kwnsxvb14n990kya0p";
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
