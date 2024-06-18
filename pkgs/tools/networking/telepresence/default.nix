{ lib, pythonPackages, fetchFromGitHub, makeWrapper
, sshfs-fuse, torsocks, sshuttle, conntrack-tools , openssh, coreutils
, iptables, bash }:

let
  sshuttle-telepresence = lib.overrideDerivation sshuttle (p: {
    postInstall = "mv $out/bin/sshuttle $out/bin/sshuttle-telepresence";
  });
in pythonPackages.buildPythonPackage rec {
  pname = "telepresence";
  version = "0.109";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = version;
    sha256 = "1ccc8bzcdxp6rh6llk7grcnmyc05fq7dz5w0mifdzjv3a473hsky";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/telepresence \
      --prefix PATH : ${lib.makeBinPath [
        sshfs-fuse
        torsocks
        conntrack-tools
        sshuttle-telepresence
        openssh
        coreutils
        iptables
        bash
      ]}
  '';

  doCheck = false;

  meta = {
    homepage = "https://www.telepresence.io/";
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    mainProgram = "telepresence";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ offline ];
  };
}
