{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tokei-${version}";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "Aaronepower";
    repo = "tokei";
    rev = "v${version}";
    sha256 = "1v9h45vspsqsy86fm78bc2g5byqa4cd9b9fbmv7imi87yjbm8i7x";
  };

  depsSha256 = "0jqzk5qlrc7pm3s7jf8130vgnrcd54izw3mx84m9b5lhf3rz98hm";

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
