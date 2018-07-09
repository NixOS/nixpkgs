{ lib, stdenv, fetchgit, fetchFromGitHub, makeWrapper, git
, python3, sshfs-fuse, torsocks, sshuttle, conntrack-tools
, openssh, which, coreutils, iptables, bash }:

let
  sshuttle-telepresence = lib.overrideDerivation sshuttle (p: {
    src = fetchgit {
      url = "https://github.com/datawire/sshuttle.git";
      rev = "32226ff14d98d58ccad2a699e10cdfa5d86d6269";
      sha256 = "1q20lnljndwcpgqv2qrf1k0lbvxppxf98a4g5r9zd566znhcdhx3";
      leaveDotGit = true;
    };

    buildInputs = p.buildInputs ++ [ git ];
    postPatch = "rm sshuttle/tests/client/test_methods_nat.py";
    postInstall = "mv $out/bin/sshuttle $out/bin/sshuttle-telepresence";
  });
in stdenv.mkDerivation rec {
  pname = "telepresence";
  version = "0.85";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "datawire";
    repo = "telepresence";
    rev = version;
    sha256 = "1iypqrx9pnhaz3p5bvl6g0c0c3d1799dv0xdjrzc1z5wa8diawvj";
  };

  buildInputs = [ makeWrapper python3 ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/libexec $out/bin

    export PREFIX=$out
    substituteInPlace ./install.sh \
      --replace "#!/bin/bash" "#!${stdenv.shell}" \
      --replace '"''${VENVDIR}/bin/pip" -q install "git+https://github.com/datawire/sshuttle.git@telepresence"' "" \
      --replace '"''${VENVDIR}/bin/sshuttle-telepresence"' '"${sshuttle-telepresence}/bin/sshuttle-telepresence"'
    ./install.sh

    wrapProgram $out/bin/telepresence \
      --prefix PATH : ${lib.makeBinPath [
        python3
        sshfs-fuse
        torsocks
        conntrack-tools
        sshuttle-telepresence
        openssh
        which
        coreutils
        iptables
        bash
      ]}
  '';

  meta = {
    homepage = https://www.telepresence.io/;
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ offline ];
  };
}
