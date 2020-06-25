{ stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fastmod";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "0089a17h0wgan3fs6x1la35lzjs1pib7p81wqkh3zcwvx8ffa8z8";
  };

  cargoSha256 = "02nkxjwfiljndmi0pv98chfsw9vmjzgmp5r14mchpayp4943qk9m";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A utility that makes sweeping changes to large, shared code bases";
    homepage = "https://github.com/facebookincubator/fastmod";
    license = licenses.asl20;
    maintainers = with maintainers; [ jduan ];
    platforms = platforms.all;
  };
}
