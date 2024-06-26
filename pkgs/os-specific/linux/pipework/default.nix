{ stdenv, lib, fetchFromGitHub, makeWrapper
, bridge-utils, iproute2, lxc, openvswitch, docker, busybox, dhcpcd
}:

stdenv.mkDerivation {
  pname = "pipework";
  version = "2017-08-22";
  src = fetchFromGitHub {
    owner = "jpetazzo";
    repo = "pipework";
    rev = "ae42f1b5fef82b3bc23fe93c95c345e7af65fef3";
    sha256 = "0c342m0bpq6ranr7dsxk9qi5mg3j5aw9wv85ql8gprdb2pz59qy8";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -D pipework $out/bin/pipework
    wrapProgram $out/bin/pipework --prefix PATH : \
      ${lib.makeBinPath [ bridge-utils iproute2 lxc openvswitch docker busybox dhcpcd ]};
  '';
  meta = with lib; {
    description = "Software-Defined Networking tools for LXC";
    mainProgram = "pipework";
    homepage = "https://github.com/jpetazzo/pipework";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
