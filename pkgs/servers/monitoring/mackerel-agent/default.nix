{ stdenv, lib, buildGoModule, fetchFromGitHub, makeWrapper, iproute2, nettools }:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.77.1";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BPLAAl4V3LN0I+ReiQX3hJcgdZZ6/7lLfBdwl9HzTHc=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = lib.optionals (!stdenv.isDarwin) [ nettools ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ iproute2 ];

  vendorHash = "sha256-K+T6DxOvVotvTZE8WhWZ0v/T6UqJ5N6xxsdJrr8DQt4=";

  subPackages = [ "." ];

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.gitcommit=v${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/mackerel-agent \
      --prefix PATH : "${lib.makeBinPath buildInputs}"
  '';

  doCheck = true;

  meta = with lib; {
    description = "System monitoring service for mackerel.io";
    homepage = "https://github.com/mackerelio/mackerel-agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ midchildan ];
  };
}
