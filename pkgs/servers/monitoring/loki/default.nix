{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, systemd }:

buildGoPackage rec {
  version = "1.5.0";
  pname = "grafana-loki";
  goPackagePath = "github.com/grafana/loki";

  doCheck = true;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "137lnd69p8qfg2z8l32dr1mrk2lhrxjx392xfij11sy5i9blfc3n";
  };

  postPatch = ''
    substituteInPlace pkg/distributor/distributor_test.go --replace \
      '"eth0", "en0", "lo0"' \
      '"lo"'
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ systemd.dev ];

  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/promtail \
      --prefix LD_LIBRARY_PATH : "${systemd.lib}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Like Prometheus, but for logs";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/loki/";
    maintainers = with maintainers; [ willibutz globin mmahut ];
    platforms = platforms.unix;
  };
}
