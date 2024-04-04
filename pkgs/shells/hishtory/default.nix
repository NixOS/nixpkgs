{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hishtory";
  version = "0.282";

  src = fetchFromGitHub {
    owner = "ddworken";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vuIeNa2Kr19L2lHTtsamjvnMsNNPQYU0yOPXXtXAOvA=";
  };

  vendorHash = "sha256-MUE6cq3mTRUcxO+lhAWr73wAzSYv9eMmv9Twpq/QHTc=";

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

