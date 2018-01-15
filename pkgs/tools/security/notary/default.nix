{ stdenv, fetchFromGitHub, buildGoPackage, git, libtool }:

buildGoPackage rec {
  name = "notary-${version}";
  version = "0.5.1";
  gitcommit = "9211198";

  src = fetchFromGitHub {
    owner = "theupdateframework";
    repo = "notary";
    rev = "v${version}";
    sha256 = "0z9nsb1mrl0q5j02jkyzbc6xqsm83qzacsckypsxcrijhw935rs5";
  };

  buildInputs = [ libtool ];

  goPackagePath = "github.com/docker/notary";

  buildPhase = ''
    cd go/src/github.com/docker/notary
    make GITCOMMIT=${gitcommit} GITUNTRACKEDCHANGES= client
  '';

  installPhase = ''
    install -D bin/notary $bin/bin/notary
  '';

  meta = with stdenv.lib; {
    description = " Notary is a project that allows anyone to have trust over arbitrary collections of data";
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
    homepage = https://github.com/theupdateframework/notary;
    maintainers = with maintainers; [ vdemeester ];
    platforms = with platforms; unix;
  };
}
