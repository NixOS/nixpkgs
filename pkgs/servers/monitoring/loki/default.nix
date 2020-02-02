{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, systemd }:

buildGoPackage rec {
  version = "1.3.0";
  pname = "grafana-loki";
  goPackagePath = "github.com/grafana/loki";

  doCheck = true;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "0b1dpb3vh5i18467qk8kpb5ic14p4p1dfyr8hjkznf6bs7g8ka1q";
  };

  postPatch = ''
    substituteInPlace pkg/distributor/distributor_test.go --replace \
      '"eth0", "en0", "lo0"' \
      '"lo"'
  '';

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
