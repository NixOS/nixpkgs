{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, installShellFiles
, dmidecode
, ethtool
, pciutils
, multipath-tools
, iproute2
, sysvinit
}:
let
  binPath = [
    iproute2
    dmidecode
    ethtool
    pciutils
    multipath-tools
    iproute2
    sysvinit
  ];
in

stdenv.mkDerivation rec {
  pname = "xsos";
  version = "0.7.19";

  src = fetchFromGitHub {
    owner = "ryran";
    repo = "xsos";
    rev = "v${version}";
    sha256 = "11cc8z3pz4gl0mwl2fc701mn4cgx50fybygx0rvs9bhvb0jnphay";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a xsos $out/bin
    wrapProgram "$out/bin/xsos" --prefix PATH : ${lib.makeBinPath binPath}
    installShellCompletion --bash --name xsos.bash xsos-bash-completion.bash
  '';

  meta = with lib; {
    description = "Summarize system info from sosreports";
    mainProgram = "xsos";
    homepage = "https://github.com/ryran/xsos";
    license = licenses.gpl3;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ maintainers.nixinator ];
  };
}
