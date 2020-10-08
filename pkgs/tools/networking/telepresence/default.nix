{ lib, pythonPackages, fetchFromGitHub, makeWrapper, git
, sshfs-fuse, torsocks, sshuttle, conntrack-tools , openssh, coreutils
, iptables, bash }:

let
  sshuttle-telepresence = 
    let
      sshuttleTelepresenceRev = "32226ff14d98d58ccad2a699e10cdfa5d86d6269";
    in
      lib.overrideDerivation sshuttle (p: {
        src = fetchFromGitHub {
          owner = "datawire";
          repo = "sshuttle";
          rev = sshuttleTelepresenceRev;
          sha256 = "1lp5b0h9v59igf8wybjn42w6ajw08blhiqmjwp4r7qnvmvmyaxhh";
        };

        SETUPTOOLS_SCM_PRETEND_VERSION="${sshuttleTelepresenceRev}";

        postPatch = "rm sshuttle/tests/client/test_methods_nat.py";
        postInstall = "mv $out/bin/sshuttle $out/bin/sshuttle-telepresence";
      });
in pythonPackages.buildPythonPackage rec {
  pname = "telepresence";
  version = "0.105";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = version;
    sha256 = "0fccbd54ryd9rcbhfh5lx8qcc3kx3k9jads918rwnzwllqzjf7sg";
  };

  buildInputs = [ makeWrapper ];

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
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ offline ];
  };
}
