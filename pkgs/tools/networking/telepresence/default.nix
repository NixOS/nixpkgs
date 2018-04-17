{ lib, stdenv, fetchgit, fetchFromGitHub, makeWrapper, git
, python3, sshfs-fuse, torsocks, sshuttle, conntrack_tools }:

let
  sshuttle-telepresence = lib.overrideDerivation sshuttle (p: {
    src = fetchgit {
      url = "https://github.com/datawire/sshuttle.git";
      rev = "8f881d131a0d5cb203c5a530d233996077f1da1e";
      sha256 = "0c760xhblz5mpcn5ddqpvivvgn0ixqbhpjsy50dkhgn6lymrx9bx";
      leaveDotGit = true;
    };

    buildInputs = p.buildInputs ++ [ git ];
    postPatch = "rm sshuttle/tests/client/test_methods_nat.py";
    postInstall = "mv $out/bin/sshuttle $out/bin/sshuttle-telepresence";
  });
in stdenv.mkDerivation rec {
  pname = "telepresence";
  version = "0.67";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "datawire";
    repo = "telepresence";
    rev = version;
    sha256 = "1bpyzgvrf43yvhwp5bzkp2qf3z9dhjma165w8ssca9g00v4b5vg9";
  };

  buildInputs = [ makeWrapper ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/libexec $out/bin
    cp cli/telepresence $out/libexec/telepresence

    makeWrapper $out/libexec/telepresence $out/bin/telepresence \
      --prefix PATH : ${lib.makeBinPath [python3 sshfs-fuse torsocks conntrack_tools sshuttle-telepresence]}
  '';

  meta = {
    homepage = https://www.telepresence.io/;
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ offline ];
  };
}
