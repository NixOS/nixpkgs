{ stdenvNoCC, lib, fetchFromGitHub, fuse-overlayfs, util-linux, makeWrapper }:
stdenvNoCC.mkDerivation rec {
  pname = "try";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "binpash";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2EDRVwW4XzQhd7rAM2rDuR94Fkaq4pH5RTooFEBBh5g=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall
    install -Dt $out/bin try
    wrapProgram $out/bin/try --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs util-linux ]}
    runHook postInstall
  '';
  meta = with lib;{
    homepage = "https://github.com/binpash/try";
    description = "Lets you run a command and inspect its effects before changing your live system";
    maintainers = with maintainers; [ pasqui23 ];
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
