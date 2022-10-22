{ lib, buildGoModule, fetchFromGitHub, makeBinaryWrapper, ffmpeg }:

buildGoModule rec {
  pname = "ytarchive";
  version = "unstable-2022-05-28";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "8d48052f432ec6f78c6aed326e8a1db31ee8e706";
    sha256 = "sha256-IsG0YPVBzsbHLNs1m/AruDmm0n7vwN9Fj1KMOoQJQ+c=";
  };

  vendorSha256 = "sha256-r9fDFSCDItQ7YSj9aTY1LXRrFE9T3XD0X36ywCfu0R8=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  ldflags = [ "-s" "-w" "-X main.Commit=-${src.rev}" ];

  postInstall = ''
    wrapProgram $out/bin/ytarchive --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/Kethsar/ytarchive";
    description = "Garbage Youtube livestream downloader";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
