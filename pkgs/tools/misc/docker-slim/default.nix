{ buildGoModule, fetchFromGitHub, stdenv, docker }:

buildGoModule rec {
  pname = "docker-slim";
  version = "1.26.1";

  goPackagePath = "github.com/docker-slim/docker-slim";
  src = fetchFromGitHub {
    owner = "docker-slim";
    repo = pname;
    rev = version;
    sha256 = "01bjb14z7yblm7qdqrx1j2pw5x5da7a6np4rkzay931gly739gbh";
  };

  subPackages = [ "cmd/docker-slim" "cmd/docker-slim-sensor" ];

  modSha256 = "05sayqbr65x98bx61ma6xnkvcsbr9g1lsviazc4szzqdizfck8yr";

  meta = with stdenv.lib; {
    description = "Minify and secure Docker containers";
    homepage = "https://github.com/docker-slim/docker-slim";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
    platforms = docker.meta.platforms;
    # internal/app/sensor/monitors/ptrace/monitor.go:151:16: undefined: system.CallNumber
    # internal/app/sensor/monitors/ptrace/monitor.go:161:15: undefined: system.CallReturnValue
    badPlatforms = [ "aarch64-linux" ];
  };
}
