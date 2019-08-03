{ stdenv, fetchFromGitLab, rustPlatform, darwin
, pkgconfig, capnproto, clang, libclang, nettle, openssl, sqlite }:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-tool";
  version = "0.9.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia";
    rev = "v${version}";
    sha256 = "13dzwdzz33dy2lgnznsv8wqnw2501f2ggrkfwpqy5x6d1kgms8rj";
  };

  nativeBuildInputs = [ pkgconfig clang libclang ];
  buildInputs = [ capnproto nettle openssl sqlite ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  LIBCLANG_PATH = libclang + "/lib";

  cargoBuildFlags = [ "--package=sequoia-tool" ];

  cargoSha256 = "1zcnkpzcar3a2fk2rn3i3nb70b59ds9fpfa44f15r3aaxajsdhdi";

  meta = with stdenv.lib; {
    description = "A command-line frontend for Sequoia, an implementation of OpenPGP";
    homepage = https://sequoia-pgp.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.all;
  };
}
