{ stdenv, fetchFromGitHub, rustPlatform, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "9.1.1";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gz8m5j9p7hwylyl7cdxbli9rpy1p6lsrbym4zk647819pg4k1jp";
  };

  cargoSha256 = "19h0ybi9qq5shvr7zix0gb24a29lqkvyfc5xbgps8wqgfrhx4nqa";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security
  ];

  meta = with stdenv.lib; {
    description = "Program that displays statistics about your code";
    homepage = https://github.com/XAMPPRocky/tokei;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
