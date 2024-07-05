{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "process-exporter";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "ncabatoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-irI1vEoLKBn7odWpFfpSwLtkStEUyxRtD/fi3CV5oNM=";
  };

  vendorHash = "sha256-Mmcc7Tp71OH5BQgMYMRhokqNDOqCudaUaCNzjOGoQ68=";

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
