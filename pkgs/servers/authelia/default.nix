{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  callPackage,
  nixosTests,
}:

let
  inherit (import ./sources.nix { inherit fetchFromGitHub; })
    pname
    version
    src
    vendorHash
    ;
  web = callPackage ./web.nix { };
in
buildGoModule rec {
  inherit
    pname
    version
    src
    vendorHash
    ;

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    cp -r ${web}/share/authelia-web/* internal/server/public_html
  '';

  subPackages = [ "cmd/authelia" ];

  ldflags =
    let
      p = "github.com/authelia/authelia/v${lib.versions.major version}/internal/utils";
    in
    [
      "-s"
      "-w"
      "-X ${p}.BuildTag=v${version}"
      "-X '${p}.BuildState=tagged clean'"
      "-X ${p}.BuildBranch=v${version}"
      "-X ${p}.BuildExtra=nixpkgs"
    ];

  # several tests with networking and several that want chromium
  doCheck = false;

  postInstall = ''
    mkdir -p $out/etc/authelia
    cp config.template.yml $out/etc/authelia

    installShellCompletion --cmd authelia \
      --bash <($out/bin/authelia completion bash) \
      --fish <($out/bin/authelia completion fish) \
      --zsh <($out/bin/authelia completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/authelia --help
    $out/bin/authelia --version | grep "v${version}"
    $out/bin/authelia build-info | grep 'v${version}\|nixpkgs'

    runHook postInstallCheck
  '';

  passthru = {
    # if overriding replace the postPatch to put your web UI output in internal/server/public_html
    inherit web;
    updateScript = ./update.sh;
    tests = { inherit (nixosTests) authelia; };
  };

  meta = with lib; {
    homepage = "https://www.authelia.com/";
    changelog = "https://github.com/authelia/authelia/releases/tag/v${version}";
    description = "A Single Sign-On Multi-Factor portal for web apps";
    longDescription = ''
      Authelia is an open-source authentication and authorization server
      providing two-factor authentication and single sign-on (SSO) for your
      applications via a web portal. It acts as a companion for reverse proxies
      like nginx, Traefik, caddy or HAProxy to let them know whether requests
      should either be allowed or redirected to Authelia's portal for
      authentication.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [
      jk
      dit7ya
    ];
    mainProgram = "authelia";
  };
}
