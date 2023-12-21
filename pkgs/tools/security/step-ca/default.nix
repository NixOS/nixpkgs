{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
, coreutils
, pcsclite
, PCSC
, pkg-config
, hsmSupport ? true
, nixosTests
}:

buildGoModule rec {
  pname = "step-ca";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    rev = "refs/tags/v${version}";
    hash = "sha256-CO9Qjx4D6qNGjOdva88KRCJOQq85r5U5nwmXC1G94dY=";
  };

  vendorHash = "sha256-Weq8sS+8gsfdoVSBDm8E2DCrngfNsolqQR2/yd9etPo=";

  ldflags = [ "-buildid=" ];

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

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;
  # Tests need to run in a reproducible order, otherwise they run unreliably on
  # (at least) x86_64-linux.
  checkFlags = [ "-p 1" ];

  passthru.tests.step-ca = nixosTests.step-ca;

  meta = with lib; {
    description = "A private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management, so you can use TLS everywhere & SSO for SSH";
    homepage = "https://smallstep.com/certificates/";
    changelog = "https://github.com/smallstep/certificates/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai mohe2015 techknowlogick ];
  };
}
