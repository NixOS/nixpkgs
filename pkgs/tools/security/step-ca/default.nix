{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  coreutils,
  pcsclite,
  PCSC,
  pkg-config,
  hsmSupport ? true,
  nixosTests,
}:

buildGoModule rec {
  pname = "step-ca";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    rev = "refs/tags/v${version}";
    hash = "sha256-sLHmeF/yh74/qsoF/DrYSAbULG9Nsvd6bvUT4tSVHdQ=";
  };

  vendorHash = "sha256-TISPM6bYzS0TpmopQLBns/rQqPKLDHK1job003vpFiQ=";

  ldflags = [
    "-w"
    "-X main.Version=${version}"
  ];

  nativeBuildInputs = lib.optionals hsmSupport [ pkg-config ];

  buildInputs =
    lib.optionals (hsmSupport && stdenv.isLinux) [ pcsclite ]
    ++ lib.optionals (hsmSupport && stdenv.isDarwin) [ PCSC ];

  postPatch = ''
    substituteInPlace systemd/step-ca.service --replace "/bin/kill" "${coreutils}/bin/kill"
  '';

  preBuild = ''
    ${lib.optionalString (!hsmSupport) "export CGO_ENABLED=0"}
  '';

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system systemd/step-ca.service
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  # Tests need to run in a reproducible order, otherwise they run unreliably on
  # (at least) x86_64-linux.
  checkFlags = [ "-p 1" ];

  passthru.tests.step-ca = nixosTests.step-ca;

  meta = with lib; {
    description = "Private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management, so you can use TLS everywhere & SSO for SSH";
    homepage = "https://smallstep.com/certificates/";
    changelog = "https://github.com/smallstep/certificates/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cmcdragonkai
      techknowlogick
    ];
  };
}
