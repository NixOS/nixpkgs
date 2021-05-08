{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
, coreutils
, pcsclite
, PCSC
, pkg-config
, hsmSupport ? true
}:

buildGoModule rec {
  pname = "step-ca";
  version = "0.15.11";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    rev = "v${version}";
    sha256 = "wFRs3n6V0z2keNVtqFw1q5jpA6BvNK5EftsNhichfsY=";
  };

  vendorSha256 = "f1NdszqYYx6X1HqwqG26jjfjXq1gDXLOrh64ccKRQ90=";

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

  # Tests fail on darwin with
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted [recovered]
  # probably some sandboxing issue
  doCheck = stdenv.isLinux;

  meta = with lib; {
    description = "A private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management, so you can use TLS everywhere & SSO for SSH";
    homepage = "https://smallstep.com/certificates/";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai mohe2015 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
