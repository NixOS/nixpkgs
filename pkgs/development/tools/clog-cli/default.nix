{ fetchFromGitHub, rustPlatform, stdenv }:

with rustPlatform;

buildRustPackage rec {
  name = "clog-cli-${version}";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "clog-tool";
    repo = "clog-cli";
    rev = "${version}";
    sha256 = "00sfbchyf50z6mb5dq1837hlrki88rrf043idy6qd1r90488jsbv";
  };

  depsSha256 = "0czv190r6xhbw33l0jhlri6rgspxb8f6dakcamh52qr3z9m0xs2x";

  meta = {
    description = "Generate changelogs from local git metadata";
    homepage = https://github.com/clog-tool/clog-cli;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.nthorne];
  };
}
