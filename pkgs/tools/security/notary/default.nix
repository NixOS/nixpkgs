{ stdenv, fetchFromGitHub, buildGoPackage, libtool }:

buildGoPackage rec {
  name = "notary-${version}";
  version = "0.6.1";
  gitcommit = "d6e1431f";

  src = fetchFromGitHub {
    owner = "theupdateframework";
    repo = "notary";
    rev = "v${version}";
    sha256 = "1ak9dk6vjny5069hp3w36dbjawcnaq82l3i2qvf7mn7zfglbsnf9";
  };

  patches = [ ./no-git-usage.patch ];

  buildInputs = [ libtool ];
  buildPhase = ''
    runHook preBuild
    cd go/src/github.com/theupdateframework/notary
    make client GITCOMMIT=${gitcommit}
    runHook postBuild
  '';

  goPackagePath = "github.com/theupdateframework/notary";

  installPhase = ''
    runHook preInstall
    install -D bin/notary $bin/bin/notary
    runHook postInstall
  '';

  #doCheck = true; # broken by tzdata: 2018g -> 2019a
  checkPhase = ''
    make test PKGS=github.com/theupdateframework/notary/cmd/notary
  '';

  meta = with stdenv.lib; {
    description = "Notary is a project that allows anyone to have trust over arbitrary collections of data";
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
    maintainers = with maintainers; [ vdemeester ma27 ];
    platforms = platforms.unix;
  };
}
