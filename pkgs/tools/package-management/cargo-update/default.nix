{ stdenv
, rustPlatform
, fetchFromGitHub
, cmake
, curl
, libgit2
, libssh2
, openssl
, pkg-config
, zlib }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-update";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "nabijaczleweli";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jyfv8aa0gp67pvv8l2vkqq4j9rgjl4rq1wn4nqxb44gmvkg15l3";
  };

  cargoPatches = [ ./0001-Generate-lockfile-for-cargo-update-v3.0.0.patch ];
  cargoSha256 = "034v1ql5k3n3rgi3aqszkybvv3vc80v263c9nlwxcwbswsh9jpp1";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libgit2 libssh2 openssl pkg-config zlib ]
    ++ stdenv.lib.optional stdenv.isDarwin curl;

  meta = with stdenv.lib; {
    description = "A cargo subcommand for checking and applying updates to installed executables";
    homepage = "https://github.com/nabijaczleweli/cargo-update";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli filalex77 ];
    platforms = platforms.all;
  };
}
