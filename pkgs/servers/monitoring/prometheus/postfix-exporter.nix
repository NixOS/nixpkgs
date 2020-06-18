{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, nixosTests
, systemd, withSystemdSupport ? true }:

with stdenv.lib;

buildGoPackage rec {
  pname = "postfix_exporter";
  version = "0.1.2";

  goPackagePath = "github.com/kumina/postfix_exporter";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "postfix_exporter";
    rev = version;
    sha256 = "1b9ib3scxni6hlw55wv6f0z1xfn27l0p29as24f71rs70pyzy4hm";
  };

  nativeBuildInputs = optional withSystemdSupport makeWrapper;
  buildInputs = optional withSystemdSupport systemd;
  buildFlags = optional (!withSystemdSupport) "-tags nosystemd";

  goDeps = ./postfix-exporter-deps.nix;
  extraSrcs = optionals withSystemdSupport [
    {
      goPackagePath = "github.com/coreos/go-systemd";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "go-systemd";
        rev = "d1b7d058aa2adfc795ad17ff4aaa2bc64ec11c78";
        sha256 = "1nz3v1b90hnmj2vjjwq96pr6psxlndqjyd30v9sgiwygzb7db9mv";
      };
    }
    {
      goPackagePath = "github.com/coreos/pkg";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "pkg";
        rev = "97fdf19511ea361ae1c100dd393cc47f8dcfa1e1";
        sha256 = "1srn87wih25l09f75483hnxsr8fc6rq3bk7w1x8125ym39p6mg21";
      };
    }
  ];

  postInstall = optionalString withSystemdSupport ''
    wrapProgram $out/bin/postfix_exporter \
      --prefix LD_LIBRARY_PATH : "${systemd.lib}/lib"
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postfix; };

  meta = {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for Postfix";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz globin ];
  };
}
