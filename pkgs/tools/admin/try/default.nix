{ stdenvNoCC, lib, fetchFromGitHub, fuse-overlayfs, util-linux, makeWrapper }:
stdenvNoCC.mkDerivation rec {
  pname = "try";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "binpash";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TTKr22FwXfPL/YrFT+r12nFSxbk/47N6rrb3Vw/lSPI=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall
    install -Dt $out/bin try
    wrapProgram $out/bin/try --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs util-linux ]}
    runHook postInstall
  '';
  meta = with lib;{
    homepage = "https://github/binpash/try";
    description = "Lets you run a command and inspect its effects before changing your live system";
    maintainers = with maintainers; [ pasqui23 ];
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
