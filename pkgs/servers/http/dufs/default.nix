{ stdenv, lib, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "dufs";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UJ93yUJqxkP+PyUrhKkjV90vr55MemC1zRbzh/gFqPU=";
  };

  cargoSha256 = "sha256-dyn0wj11MC9NYwULsR6ytYUl+8wsRkVLBIwcgM5mMNQ=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "A file server that supports static serving, uploading, searching, accessing control, webdav";
    homepage = "https://github.com/sigoden/dufs";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.holymonson ];
  };
}
