{ lib, fetchFromGitHub, rustPlatform, makeWrapper, iperf3 }:

rustPlatform.buildRustPackage rec {
  pname = "iperf3d";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "wobcom";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pMwGoBgFRVY+H51k+YCamzHgBoaJVwEVqY0CvMPvE0w=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/iperf3d --prefix PATH : ${iperf3}/bin
  '';

  cargoHash = "sha256-3mJBn70sSoDL9GNxgEZqA8S4GrY+DjnYY9Cc5Xe1GFQ=";

  meta = with lib; {
    description = "A iperf3 client and server wrapper for dynamic server ports";
    mainProgram = "iperf3d";
    homepage = "https://github.com/wobcom/iperf3d";
    license = licenses.mit;
    maintainers = with maintainers; [ netali ] ++ teams.wdz.members;
  };
}
