{
  lib,
  pythonPackages,
  fetchFromGitHub,
  makeWrapper,
  sshfs-fuse,
  torsocks,
  sshuttle,
  conntrack-tools,
  openssh,
  coreutils,
  iptables,
  bash,
}:

let
  sshuttle-telepresence = lib.overrideDerivation sshuttle (p: {
    postInstall = "mv $out/bin/sshuttle $out/bin/sshuttle-telepresence";
  });
in
pythonPackages.buildPythonPackage rec {
  pname = "telepresence";
  version = "0.109";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = version;
    hash = "sha256-fmo4DlFjy99crICX3w52BTBfLcvvTEoNzOb2xv5CjLE=";
  };

  patches = [
    ./fix-versioneer.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/telepresence \
      --prefix PATH : ${
        lib.makeBinPath [
          sshfs-fuse
          torsocks
          conntrack-tools
          sshuttle-telepresence
          openssh
          coreutils
          iptables
          bash
        ]
      }
  '';

  doCheck = false;

  meta = {
    homepage = "https://www.telepresence.io/";
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    mainProgram = "telepresence";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
