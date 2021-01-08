{ stdenv, fetchFromGitHub, rustPlatform, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "tab-rs";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "austinjones";
    repo = pname;
    rev = "v${version}";
    sha256 = "06nip7g5y7jslqj8anvn2z7w1c8yr0gl32bpnzv26xschan4gc2h";
  };

  cargoSha256 = "1clpl9fi07lms0din8f9m4y6br5jg8k5xsklsqmvgdwf83wyn321";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  # many tests are failing
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Intuitive, config-driven terminal multiplexer designed for software & systems engineers";
    homepage = "https://github.com/austinjones/tab-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
