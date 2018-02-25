{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "kubectl";

  version = "v1.8.1";

  src =
    if stdenv.system == "x86_64-darwin" then
      fetchurl {
        url = "https://storage.googleapis.com/kubernetes-release/release/${version}/bin/darwin/amd64/kubectl";
        sha256 = "034g4j0vnqcw1ln6cnj2hy5sbnk0d7f11ayxv8j2al72czgbi3z7";
      }
    else
      fetchurl {
        url = "https://storage.googleapis.com/kubernetes-release/release/${version}/bin/linux/amd64/kubectl";
        sha256 = "1bdgsqbmcacrj56x2p6qkqghsrr3hpb64hr54vyi13smisvpv9g5";
      };

  phases = [ "installPhase" "postInstall" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/kubectl
  '';

  postInstall = ''
    chmod +x $out/bin/kubectl
  '';

  meta = with stdenv.lib; {
    description = "Kubernetes command line tool";
    longDescription = "The kubernetes command line tool. This package has the program: kubectl";
    license = licenses.asl20;
    homepage = "https://kubernetes.io/docs/user-guide/kubectl";
    maintainers = with maintainers; [ jthompson ];
    platforms = with platforms; linux ++ darwin;
  };

}
