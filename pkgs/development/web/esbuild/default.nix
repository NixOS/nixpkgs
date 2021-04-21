{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.11.12";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mxj4mrq1zbvv25alnc3s36bhnnhghivgwp45a7m3cp1389ffcd1";
  };

  vendorSha256 = "1n5538yik72x94vzfq31qaqrkpxds5xys1wlibw2gn2am0z5c06q";

  meta = with lib; {
    description = "An extremely fast JavaScript bundler and minifier";
    homepage = "https://esbuild.github.io/";
    license = licenses.mit;
  };
}
