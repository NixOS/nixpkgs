{ stdenv, lib, buildGoPackage, fetchFromGitHub, fetchpatch, makeWrapper, systemd }:

buildGoPackage rec {
  version = "1.6.1";
  pname = "grafana-loki";
  goPackagePath = "github.com/grafana/loki";

  doCheck = true;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "0bakskzizazc5cd6km3n6facc5val5567zinnxg3yjy29xdi64ww";
  };

  postPatch = ''
    substituteInPlace pkg/distributor/distributor_test.go --replace \
      '"eth0", "en0", "lo0"' \
      '"lo"'
  '';

  patches = [
    (fetchpatch {
      # https://github.com/grafana/loki/pull/2647
      url = "https://github.com/grafana/loki/commit/85696d00eb5c3aa4aa6289e12b3656a42f581e58.patch";
      sha256 = "1drkc1qdmfbh243kwd3v58ycgf7pbq1rd9f9j4ahcqbwfkhbi7di";
    })
    (fetchpatch {
      # Fix expected return value in Test_validateDropConfig
      # https://github.com/grafana/loki/issues/2519
      url = "https://github.com/grafana/loki/commit/1316c0f0c5cda7c272c4873ea910211476fc1db8.patch";
      sha256 = "06hwga58qpmivbhyjgyqzb75602hy8212a4b5vh99y9pnn6c913h";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ systemd.dev ];

  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/promtail \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Like Prometheus, but for logs";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/loki/";
    maintainers = with maintainers; [ willibutz globin mmahut ];
    platforms = platforms.unix;
  };
}
