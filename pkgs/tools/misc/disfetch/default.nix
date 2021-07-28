{ stdenv
, lib
, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "llathasa-veleth";
    repo = "disfetch";
    rev = version;
    sha256 = "sha256-dst/k62w+3uTDdR0ZpSYt6pahx3aMQn4NFeRXHdNFTY=";
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
