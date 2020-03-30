{ stdenv, rustPlatform, fetchFromGitHub }:

with rustPlatform;

buildRustPackage rec {
  pname = "kubie";
  version = "0.7.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "0c94ggrkzyy8zl2z5r4pgfscyhcjp4x64k3bl2byqp3ysgjwkjqx";
  };

  cargoSha256 = "1lzyda838s9fmg8hibg2w2wszwyvvqsy20w9877skfcx370rvndi";

  meta = with stdenv.lib; {
    description =
      "Shell independent context and namespace switcher for kubectl";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
    platforms = platforms.all;
  };
}
