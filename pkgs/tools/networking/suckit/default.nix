{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "suckit";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "skallwar";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wr03yvrqa9p6m127fl4hcf9057i11zld898qz4kbdyiynpi0166";
  };

  cargoSha256 = "sha256-6otIWAAf9pI4A8kxK3dyOVpkw+SJ3/YAvTahDSXMWNc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # requires internet access
  checkFlags = [ "--skip=test_download_url" ];

  meta = with lib; {
    description = "Recursively visit and download a website's content to your disk";
    homepage = "https://github.com/skallwar/suckit";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
