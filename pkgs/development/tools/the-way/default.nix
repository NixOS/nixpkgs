{ stdenv, fetchFromGitHub, rustPlatform, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "1whmvzpqm8x1q45mzrp4p40nj251drcryj9z4qjxgjlfsd5d1fxq";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin  [ AppKit Security ];

  cargoSha256 = "0adhgp6blwx7s1hlwqzzsgkzc43q9avxx8a9ykvvv2s1w7m9ql78";
  #checkFlags = "--test-threads=1";
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ numkem ];
  };
}
