{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, systemd }:

buildGoPackage rec {
  version = "1.1.0";
  pname = "grafana-loki";
  goPackagePath = "github.com/grafana/loki";

  doCheck = true;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "1c9bw5bib577pgjd71skncxf3cdcyj1ab36j6ag7szl2kym62j6x";
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
