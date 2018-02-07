{ stdenv, fetchurl, crystal, libyaml, which }:

stdenv.mkDerivation rec {
  name = "shards-${version}";
  version = "0.7.2";

  src = fetchurl {
    url = "https://github.com/crystal-lang/shards/archive/v${version}.tar.gz";
    sha256 = "1qiv9zzpccf6i5r2qrzbl84wgvqapbs0csazayhcpzfjfhg6i8wp";
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
    maintainers = with maintainers; [ sifmelcara ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
