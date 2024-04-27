{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hishtory";
  version = "0.292";

  src = fetchFromGitHub {
    owner = "ddworken";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jCm/iSPKjQ0RRGw8bXPiKutMk/fM6mQ/Na6j+RrE0b4=";
  };

  vendorHash = "sha256-9ZRhbRxQV9pzFzDhWIjgzQWXFWuzWMdeoNl4YsDuPFc=";

  ldflags = [ "-X github.com/ddworken/hishtory/client/lib.Version=${version}" ];

  subPackages = [ "." ];

  excludedPackages = [ "backend/server" ];

  postInstall = ''
    mkdir -p $out/share/hishtory
    cp client/lib/config.* $out/share/hishtory
  '';

  doCheck = true;

  meta = with lib; {
    description = "Your shell history: synced, queryable, and in context";
    homepage = "https://github.com/ddworken/hishtory";
    license = licenses.mit;
    maintainers = with maintainers; [ Enzime ];
    mainProgram = "hishtory";
  };
}

