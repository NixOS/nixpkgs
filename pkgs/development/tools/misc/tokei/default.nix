{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tokei-${version}";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "Aaronepower";
    repo = "tokei";
    rev = "v${version}";
    sha256 = "1sfwmjlvjrd8r0ynnayw7g3514mfiky2j30byphaagdw4jkxbd7c";
  };

  cargoSha256 = "0v29gych757h7vv5jsg7rpl705gpqn0ya8ai53582qd2cc6yz4c3";

  meta = with stdenv.lib; {
    description = "Count code, quickly";
    homepage = https://github.com/Aaronepower/tokei;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
