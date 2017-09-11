{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tokei-${version}";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "Aaronepower";
    repo = "tokei";
    rev = "v${version}";
    sha256 = "1bzs3mr6f9bna39b9ddwwq0raas07nbn106mnq3widxg59i0gxhd";
  };

  depsSha256 = "1cz93mrpxmyrza0ipdyg2a6mynl66plpsb446wxnmmy7y7zd6xbf";

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
