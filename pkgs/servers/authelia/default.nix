{ lib, fetchFromGitHub, buildGoModule, installShellFiles, buildNpmPackage }:

buildGoModule rec {
  pname = "authelia";
  version = "4.37.5";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    sha256 = "sha256-xsdBnyPHFIimhp2rcudWqvVR36WN4vBXbxRmvgqMcDw=";
  };
  vendorSha256 = "sha256-mzGE/T/2TT4+7uc2axTqG3aeLMnt1r9Ya7Zj2jIkw/w=";

  nativeBuildInputs = [ installShellFiles ];

  web = buildNpmPackage {
    inherit src version;

    pname = "authelia-web";
    sourceRoot = "source/web";

    patches = [
      ./change-web-out-dir.patch
    ];

    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';

    npmDepsHash = "sha256-MGs6UAxT5QZd8S3AO75mxuCb6U0UdRkGEjenOVj+Oqs=";

    npmFlags = [ "--legacy-peer-deps" ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      mv dist $out/share/authelia-web

      runHook postInstall
    '';
  };


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
    maintainers = with maintainers; [ jk raitobezarius dit7ya ];
  };
}
