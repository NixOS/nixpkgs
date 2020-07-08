{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q7yg90yxnpaafg6sg7mqkh86qkn43kxy73p9nqkkgrikdnrjh5a";
  };

  cargoSha256 = "1a747bmc6s007ram0w4xf1y2nb3pphvqnlx59098lr3v7gllp7x3";
  checkFlags = "--test-threads=1";

  meta = with stdenv.lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ numkem ];
    platforms = platforms.all;
  };
}
