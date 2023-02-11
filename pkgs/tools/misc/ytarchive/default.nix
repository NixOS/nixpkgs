{ lib, buildGoModule, fetchFromGitHub, fetchpatch, makeBinaryWrapper, ffmpeg }:

buildGoModule rec {
  pname = "ytarchive";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "v${version}";
    hash = "sha256-fBYwLGg1h5pn8ZP5vZmzzIEvuXlBJ27p4tv7UVMwOEw=";
  };

  patches = [
    # Increase the Go version required. See https://github.com/Kethsar/ytarchive/pull/127
    (fetchpatch {
      url = "https://github.com/Kethsar/ytarchive/commit/2a995ead4448d03c975378a1932ad975da1a6383.patch";
      sha256 = "sha256-Y+y/Sp/xOS9tBT+LQQ9vE+4n/2RH10umFEEEEVXgtuc=";
    })
  ];

  vendorHash = "sha256-8uTDcu8ucPzck+1dDoySGtc3l1+1USxCfUvdS+ncsnU=";

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
