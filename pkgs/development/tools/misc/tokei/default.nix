{ stdenv, fetchurl, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "tokei-${version}";
  version = "3.0.0";
  src = fetchurl {
    url = "https://github.com/Aaronepower/tokei/archive/${version}.tar.gz";
    sha256 = "0xymz52gpasihzhxglzx4wh0312zkraxy4yrpxz694zalf2s5vj5";
  };

  depsSha256 = "1syx8qzjn357dk2bf4ndmgc4zvrglmw88qiw117h6s511qyz8z0z";

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/tokei $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Count code, quickly";
    homepage = https://github.com/Aaronepower/tokei;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
