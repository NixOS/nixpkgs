{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vouch-proxy";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-q4tylXW219jzWrdzOQxewRh1advYEouEKiNJvvnIp9U=";
  };

  vendorHash = "sha256-IUjIGht/oQiWKHfbW7nJaybKpKs179mOkpLIwAb8/hk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    export VOUCH_ROOT=$PWD
  '';

  meta = with lib; {
    homepage = "https://github.com/vouch/vouch-proxy";
    description = "An SSO and OAuth / OIDC login solution for NGINX using the auth_request module";
    changelog = "https://github.com/vouch/vouch-proxy/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ leona erictapen ];
    platforms = platforms.linux;
    mainProgram = "vouch-proxy";
  };
}
