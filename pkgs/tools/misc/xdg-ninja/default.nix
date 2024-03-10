{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper, jq, glow }:

stdenvNoCC.mkDerivation rec {
  pname = "xdg-ninja";
  version = "0.2.0.2";

  src = fetchFromGitHub {
    owner = "b3nj5m1n";
    repo = "xdg-ninja";
    rev = "v${version}";
    sha256 = "sha256-ASJIFQ/BpZMQGRtw8kPhtMCbXC1eb/X8TWQz+CAnaSM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 xdg-ninja.sh "$out/share/xdg-ninja/xdg-ninja.sh"
    install -Dm644 programs/* -t "$out/share/xdg-ninja/programs"

    mkdir -p "$out/bin"
    ln -s "$out/share/xdg-ninja/xdg-ninja.sh" "$out/bin/xdg-ninja"

    wrapProgram "$out/bin/xdg-ninja" \
      --prefix PATH : "${lib.makeBinPath [ glow jq ]}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A shell script which checks your $HOME for unwanted files and directories";
    homepage = "https://github.com/b3nj5m1n/xdg-ninja";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ arcuru ];
    mainProgram = "xdg-ninja";
  };
}
