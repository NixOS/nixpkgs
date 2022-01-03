{ stdenv
, lib
, rustPlatform
, fetchFromGitLab
, llvmPackages
, pkg-config
, openssl
, sqlite
, nettle
, cargo
, rustc
, capnproto
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-octopus-librnp";
  version = "1.2.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-octopus-librnp";
    rev = "v1.2.1";
    hash = "sha256:1xmijvkgqqq35amjnnpccflqq2nz6w9jcnmyvp1c20wm8prrdkng";
  };

  cargoSha256 = "sha256:0d6935xgx7iih7k8mdb3mj6x1zcsghwz7klfrrrrqfr44hzs170d";

  # Rust *-sys packages, like nettle-sys, require this to be set.
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  buildInputs = [ openssl sqlite nettle ];

  nativeBuildInputs = [ pkg-config cargo rustc llvmPackages.clang capnproto ];

  meta = with lib; {
    description =
      "A Sequoia-based OpenPGP Backend for Thunderbird";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-octopus-librnp";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ puzzlewolf ];
    platforms = platforms.all;
  };
}
