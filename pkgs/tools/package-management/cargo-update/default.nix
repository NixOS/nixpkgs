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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "nabijaczleweli";
    repo = pname;
    rev = "v${version}";
    sha256 = "143aczay7i3zbhbvv4cjf6hns5w8j52rfdaq8ff0r8v3qghd2972";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "0mxc752hmd7r29camq4f4qzwx0w008rqlq07j2r26z4ygvlrkc3a";

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
