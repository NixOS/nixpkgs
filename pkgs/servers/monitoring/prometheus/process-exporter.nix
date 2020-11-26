{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "process-exporter";
  version = "0.7.1";

  goPackagePath = "github.com/ncabatoff/process-exporter";

  src = fetchFromGitHub {
    owner = "ncabatoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jkh4xzjlrlabpll3igpyhqs35f1dxifjkbfxvijjcq9yahxfj0x";
  };

  postPatch = ''
    substituteInPlace proc/read_test.go --replace /bin/cat cat
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Prometheus exporter that mines /proc to report on selected processes";
    homepage = "https://github.com/ncabatoff/process-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.linux;
  };
}
