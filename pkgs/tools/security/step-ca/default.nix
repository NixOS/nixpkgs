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
  version = "0.15.11";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    rev = "v${version}";
    sha256 = "wFRs3n6V0z2keNVtqFw1q5jpA6BvNK5EftsNhichfsY=";
  };

  vendorSha256 = "f1NdszqYYx6X1HqwqG26jjfjXq1gDXLOrh64ccKRQ90=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals (stdenv.isLinux) [ pcsclite ]
    ++ lib.optionals (stdenv.isDarwin) [ PCSC ];

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
