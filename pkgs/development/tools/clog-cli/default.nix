{ fetchFromGitHub, rustPlatform, lib }:

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

  cargoSha256 = "042p07c1janq8k66r8a9527yklrmjrvdp5mv3bv59nki8qvgqqgf";

  meta = {
    description = "Generate changelogs from local git metadata";
    homepage = "https://github.com/clog-tool/clog-cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [lib.maintainers.nthorne];
  };
}
