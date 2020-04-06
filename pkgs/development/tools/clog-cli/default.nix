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

  cargoSha256 = "1s7g9mcjyp0pjjxma1mb290fi7fk54qy2khh1zksxhr4d3mciv08";

  meta = {
    description = "Generate changelogs from local git metadata";
    homepage = https://github.com/clog-tool/clog-cli;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [stdenv.lib.maintainers.nthorne];
  };
}
