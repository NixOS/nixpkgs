{ lib, buildGoModule, fetchFromGitHub, getent }:

buildGoModule rec {
  inherit getent;
  pname = "otel-cli";
  version = "0.0.19";
  src = fetchFromGitHub {
    owner = "equinix-labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jQKoj55ty68yMDOa7/ulH1xZdI1GUoFyiPWdBHRWDNM=";
  };
  checkInputs = [ getent ];
  vendorSha256 = "sha256-IJ2Gq5z1oNvcpWPh+BMs46VZMN1lHyE+M7kUinTSRr8=";
  preCheck = ''
    # This is necessary due to path hard-coding in the E2E Acceptance Test
    ln -s ${getent}/bin/getent /bin/getent
    # Must build full binary cli app for test run
    go build .
  '';
  doCheck = false;
  meta = with lib; {
    homepage = "https://github.com/equinix-labs/otel-cli";
    description = "a cli tool for otel instrumenting command line work";
    platforms = ["x86_64-linux" "i686-linux" "aarch64-linux"];
    license = with licenses; [asl20];
    maintainers = with lib.maintainers; [ emattiza ];
  };
}
