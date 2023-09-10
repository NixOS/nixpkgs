{ lib, stdenv, buildGoModule, fetchFromGitHub, pkg-config, libsecret, testers, docker-credential-helpers }:

buildGoModule rec {
  pname = "docker-credential-helpers";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3zWlYW+2LA/JK/lv/OTzMlF2HlQPID0WYks0dQrP3GY=";
  };

  vendorHash = null;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ libsecret ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/docker/docker-credential-helpers/credentials.Version=${version}"
  ];

  buildPhase =
    let
      cmds = if stdenv.isDarwin then [ "osxkeychain" "pass" ] else [ "secretservice" "pass" ];
    in
    ''
      for cmd in ${builtins.toString cmds}; do
        go build -ldflags "${builtins.toString ldflags}" -trimpath -o bin/docker-credential-$cmd ./$cmd/cmd
      done
    '';

  installPhase = ''
    install -Dm755 -t $out/bin bin/docker-credential-*
  '';

  passthru.tests.version = testers.testVersion {
    package = docker-credential-helpers;
    command = "docker-credential-pass version";
  };

  meta = with lib; {
    description = "Suite of programs to use native stores to keep Docker credentials safe";
    homepage = "https://github.com/docker/docker-credential-helpers";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  } // lib.optionalAttrs stdenv.isDarwin {
    mainProgram = "docker-credential-osxkeychain";
  };
}
