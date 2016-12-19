{ stdenv, fetchurl, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "tokei-${version}";
  version = "4.0.0";
  src = fetchurl {
    url = "https://github.com/Aaronepower/tokei/archive/${version}.tar.gz";
    sha256 = "1c7z3dgxr76dq6cvan3hgqlkcv61gmg6fkv6b98viymh4fy9if68";
  };

  depsSha256 = "0v4gplk7mkkik9vr1lqsr0yl1kqkqh14ncw95yb9iv7hcxvmcqn3";

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
