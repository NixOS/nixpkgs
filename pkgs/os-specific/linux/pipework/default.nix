{ stdenv, lib, fetchFromGitHub, makeWrapper
, bridge-utils, iproute, lxc, openvswitch, docker, busybox, dhcpcd, dhcp
}:

stdenv.mkDerivation rec {
  name = "pipework-${version}";
  version = "2015-07-30";
  src = fetchFromGitHub {
    owner = "jpetazzo";
    repo = "pipework";
    rev = "5a46ecb5f8f933fd268ef315f58a1eb1c46bd93d";
    sha256 = "02znyg5ir37s8xqjcqqz6xnwyqxapn7c4scyqkcapxr932hf1frh";
  };
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp pipework $out/bin
    wrapProgram $out/bin/pipework --prefix PATH : \
      ${lib.makeBinPath [ bridge-utils iproute lxc openvswitch docker busybox dhcpcd dhcp ]};
  '';
  meta = with lib; {
    description = "Software-Defined Networking tools for LXC";
    homepage = https://github.com/jpetazzo/pipework;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
