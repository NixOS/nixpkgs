{ fetchFromGitHub, rustPlatform, stdenv }:

with rustPlatform;

buildRustPackage rec {
  name = "clog-cli-${version}";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "clog-tool";
    repo = "clog-cli";
    rev = "v${version}";
    sha256 = "1wxglc4n1dar5qphhj5pab7ps34cjr7jy611fwn72lz0f6c7jp3z";
  };

  cargoSha256 = "1pi8fh6vz6m5hr38wm0v0hxp1yxm1ma8yzish3b78zkv8f90kmv0";

  meta = {
    description = "Generate changelogs from local git metadata";
    homepage = https://github.com/clog-tool/clog-cli;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [stdenv.lib.maintainers.nthorne];
  };
}
