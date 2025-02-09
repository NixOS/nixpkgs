{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "process-exporter";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "ncabatoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WGfKF7GE9RHrMiqbx5c3WtHEKUA2SShwuUUAqAeiMts=";
  };

  vendorHash = "sha256-ZxN9BAn6b7OFXMiIbMqpEQsN9lTzt/A2LDu/Vtggtqs=";

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
