{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "process-exporter";
  version = "0.5.0";

  goPackagePath = "github.com/ncabatoff/process-exporter";

  goDeps = ./process-exporter_deps.nix;

  src = fetchFromGitHub {
    owner = "ncabatoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "129vqry3l8waxcyvx83wg0dvh3qg4pr3rl5fw7vmhgdzygbaq3bq";
  };

  postPatch = ''
    substituteInPlace proc/read_test.go --replace /bin/cat cat
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Prometheus exporter that mines /proc to report on selected processes";
    homepage = "https://github.com/ncabatoff/process-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainers."1000101" ];
    platforms = platforms.linux;
  };
}
