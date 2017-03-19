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

  depsSha256 = "0gkg3bxx7nxsvff33n7pif731djfvlzk0msia27h0wq0mazq7kw3";

  meta = {
    description = "Generate changelogs from local git metadata";
    homepage = https://github.com/clog-tool/clog-cli;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.nthorne];
  };
}
