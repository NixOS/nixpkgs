{ stdenv, fetchurl, crystal, libyaml, which }:

stdenv.mkDerivation rec {
  name = "shards-${version}";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/crystal-lang/shards/archive/v${version}.tar.gz";
    sha256 = "31de819c66518479682ec781a39ef42c157a1a8e6e865544194534e2567cb110";
  };

  buildInputs = [ crystal libyaml which ];

  buildFlags = [ "CRFLAGS=" "release" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/shards $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://crystal-lang.org/;
    license = licenses.asl20;
    description = "Dependency manager for the Crystal language";
    maintainers = with maintainers; [ mingchuan ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
