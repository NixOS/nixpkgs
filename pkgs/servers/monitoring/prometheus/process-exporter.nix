{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "process-exporter";
  version = "0.7.10";

  src = fetchFromGitHub {
    owner = "ncabatoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TAgMA9IV3i8dpgOBDmnlt4iyGlmWN5Nj3BexXb5vzlc=";
  };

  vendorSha256 = "sha256-LAEnXJ3qShfCGjtsYAGyW5x/TTFQxQxXM0hebJrqiW4=";

  postPatch = ''
    substituteInPlace proc/read_test.go --replace /bin/cat cat
  '';

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) process; };

  meta = with lib; {
    description = "Prometheus exporter that mines /proc to report on selected processes";
    homepage = "https://github.com/ncabatoff/process-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.linux;
  };
}
