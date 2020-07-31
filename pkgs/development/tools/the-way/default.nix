{ stdenv, fetchFromGitHub, rustPlatform, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h33jsai8gvfp0js06qa8cqpzfbjkd001kfj6p24d08ds2i00asx";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin  [ AppKit Security ];

  cargoSha256 = "1r0mv1q1bz67zbxnd5qmji4svcbln8h5h0gysfddpn4dy9424fp3";
  #checkFlags = "--test-threads=1";
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ numkem ];
  };
}
