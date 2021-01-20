{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
, pcsclite
, PCSC
, pkg-config
}:

buildGoModule rec {
  pname = "step-ca";
  version = "0.15.6";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    rev = "v${version}";
    sha256 = "0n26692ph4q4cmrqammfazmx1k9p2bydwqc57q4hz5ni6jd31zbz";
  };

  vendorSha256 = "0w0phyqymcg2h2jjasxmkf4ryn4y1bqahcy94rs738cqr5ifyfbg";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optional stdenv.isDarwin PCSC;

  # Tests fail on darwin with
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted [recovered]
  # probably some sandboxing issue
  doCheck = stdenv.isLinux;

  meta = with lib; {
    description = "A private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management, so you can use TLS everywhere & SSO for SSH";
    homepage = "https://smallstep.com/certificates/";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
