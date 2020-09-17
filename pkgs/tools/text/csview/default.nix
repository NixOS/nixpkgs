{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1956vjs210i9xli6dzr6afbz4z4c76m5iplrisznshky1ac19yk6";
  };

  cargoSha256 = "0w3rs56jbqx4b38fj5wkshkx626zii515mklwyy10cfwm6icnklf";

  meta = with stdenv.lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.mlvzk ];
    platforms = platforms.unix;
  };
}
