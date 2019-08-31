{ fetchFromGitHub, rustPlatform, stdenv }:

with rustPlatform;

buildRustPackage rec {
  pname = "clog-cli";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "clog-tool";
    repo = "clog-cli";
    rev = "v${version}";
    sha256 = "1wxglc4n1dar5qphhj5pab7ps34cjr7jy611fwn72lz0f6c7jp3z";
  };

  cargoSha256 = "1i1aq7bwkx8sqrlpxq24ldh908j72lwi2r3sg9zaz5p8xq1xgq6p";

  meta = {
    description = "Generate changelogs from local git metadata";
    homepage = https://github.com/clog-tool/clog-cli;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [stdenv.lib.maintainers.nthorne];
  };
}
