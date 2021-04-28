{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.11.15";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "1j6qli26i2hwkjqcigz7vyx6hg9daq4vlqigv7ddslw3h8hnp0md";
  };

  vendorSha256 = "1n5538yik72x94vzfq31qaqrkpxds5xys1wlibw2gn2am0z5c06q";

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 ];
  };
}
