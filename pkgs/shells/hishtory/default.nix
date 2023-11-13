{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hishtory";
  version = "0.251";

  src = fetchFromGitHub {
    owner = "ddworken";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-as7OO14S2ia9ty/HRP35Zw9EOvFxBQeCzCluDWo/VnI=";
  };

  vendorHash = "sha256-HzHLGrPXUSkyt2Dr7tLjfJrbg/EPBHkljoXIlPWIppU=";

  ldflags = [ "-s -w -X github.com/ddworken/hishtory/client/lib.Version=${version} -extldflags '-static'" ];

  excludedPackages = [ "backend/server" "client" ];

  postInstall = ''
    mkdir -p $out/share/hishtory
    cp client/lib/config.* $out/share/hishtory
  '';

  doCheck = false;

  meta = with lib; {
    description = "Your shell history: synced, queryable, and in context";
    homepage = "https://github.com/ddworken/hishtory";
    license = licenses.mit;
    maintainers = with maintainers; [ Enzime ];
  };
}
