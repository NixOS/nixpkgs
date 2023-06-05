{ stdenv, lib, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "dufs";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WSTY9j7wfoAqovLb9reNe7LXTjy40QObJNfgiidOINQ=";
  };

  cargoHash = "sha256-sQQUpbvr5IpsUTTznAfUJ5MvGh8rZ0tuZQkxMVpI2wM=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # FIXME: checkPhase on darwin will leave some zombie spawn processes
  # see https://github.com/NixOS/nixpkgs/issues/205620
  doCheck = !stdenv.isDarwin;
  checkFlags = [
    # tests depend on network interface, may fail with virtual IPs.
    "--skip=validate_printed_urls"
  ];

  meta = with lib; {
    description = "A file server that supports static serving, uploading, searching, accessing control, webdav";
    homepage = "https://github.com/sigoden/dufs";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.holymonson ];
  };
}
