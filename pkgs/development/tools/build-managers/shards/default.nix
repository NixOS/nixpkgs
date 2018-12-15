{ stdenv, fetchFromGitHub, crystal, pcre, libyaml, which }:

stdenv.mkDerivation rec {
  name = "shards-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner  = "crystal-lang";
    repo   = "shards";
    rev    = "v${version}";
    sha256 = "1cjn2lafr08yiqzlhyqx14jjjxf1y24i2kk046px07gljpnlgqwk";
  };

  buildInputs = [ crystal libyaml pcre which ];

  buildFlags = [ "CRFLAGS=--release" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/shards $out/bin/shards

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Dependency manager for the Crystal language";
    license     = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (crystal.meta) homepage platforms;
  };
}
