{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.11.14";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "0qxylzc7lzpsp5hm3dl5jvy9aca8azn8dmbjz9z5n5rkdmm8vd9p";
  };

  vendorSha256 = "1n5538yik72x94vzfq31qaqrkpxds5xys1wlibw2gn2am0z5c06q";

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 ];
  };
}
