{ lib, fetchFromGitHub, buildGoModule, pkcs11Support ? true }:

buildGoModule rec {
  pname = "notary";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "notaryproject";
    repo = "notary";
    rev = "v${version}";
    sha256 = "sha256-jTf9CwyUgDWY2lmi+6HWOOc4rNWfNke0CfL3VEbHRVY=";
  };

  vendorSha256 = null;

  excludedPackages = [ "cmd/escrow" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/theupdateframework/notary/version.NotaryVersion=${version}"
  ];

  tags = [ ] ++ lib.optionals pkcs11Support [ "pkcs11key" ];

  checkFlags = [ "-short" ];

  meta = with lib; {
    description = "A project that allows anyone to have trust over arbitrary collections of data";
    longDescription = ''
      The Notary project comprises a server and a client for running and
      interacting with trusted collections. See the service architecture
      documentation for more information.

      Notary aims to make the internet more secure by making it easy for people
      to publish and verify content. We often rely on TLS to secure our
      communications with a web server which is inherently flawed, as any
      compromise of the server enables malicious content to be substituted for
      the legitimate content.

      With Notary, publishers can sign their content offline using keys kept
      highly secure. Once the publisher is ready to make the content available,
      they can push their signed trusted collection to a Notary Server.

      Consumers, having acquired the publisher's public key through a secure
      channel, can then communicate with any notary server or (insecure) mirror,
      relying only on the publisher's key to determine the validity and
      integrity of the received content.
    '';
    license = licenses.asl20;
    homepage = "https://github.com/notaryproject/notary";
    maintainers = with maintainers; [ vdemeester ];
  };
}
