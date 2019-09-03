{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, systemd }:

buildGoPackage rec {
  version = "0.3.0";
  pname = "grafana-loki";
  goPackagePath = "github.com/grafana/loki";

  doCheck = true;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "1b61fqk6ah4qps4nq7ypdax4i7pkhjxdw4qrhc1zvzzhxr7x13rs";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ systemd.dev ];

  preFixup = ''
    wrapProgram $bin/bin/promtail \
      --prefix LD_LIBRARY_PATH : "${systemd.lib}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Like Prometheus, but for logs.";
    license = licenses.asl20;
    homepage = "https://grafana.com/loki";
    maintainers = with maintainers; [ willibutz globin ];
    platforms = platforms.linux;
  };
}
