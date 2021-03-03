{ stdenv, lib, buildGoModule, fetchFromGitHub, makeWrapper, nixosTests, systemd
}:

buildGoModule rec {
  version = "2.1.0";
  pname = "grafana-loki";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "O/3079a67j1i9pgf18SBx0iJcQPVmb0H+K/PzQVBCDQ=";
  };

  vendorSha256 = null;

  subPackages = [ "..." ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.isLinux [ systemd.dev ];

  preFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/promtail \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
  '';

  passthru.tests = { inherit (nixosTests) loki; };

  buildFlagsArray = let t = "github.com/grafana/loki/pkg/build"; in ''
    -ldflags=-s -w -X ${t}.Version=${version} -X ${t}.BuildUser=nix@nixpkgs -X ${t}.BuildDate=unknown -X ${t}.Branch=unknown -X ${t}.Revision=unknown
  '';

  doCheck = true;

  meta = with lib; {
    description = "Like Prometheus, but for logs";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/loki/";
    maintainers = with maintainers; [ willibutz globin mmahut ];
    platforms = platforms.unix;
  };
}
