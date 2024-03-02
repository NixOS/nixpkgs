{ lib, buildGoModule, fetchFromGitHub, fetchpatch, installShellFiles }:

buildGoModule rec {
  pname = "sift";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "svent";
    repo = "sift";
    rev = "v${version}";
    hash = "sha256-IZ4Hwg5NzdSXtrIDNxtkzquuiHQOmLV1HSx8gpwE/i0=";
  };

  vendorHash = "sha256-y883la4R4jhsS99/ohgBC9SHggybAq9hreda6quG3IY=";

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/svent/sift/commit/b56fb3d0fd914c8a6c08b148e15dd8a07c7d8a5a.patch";
      hash = "sha256-mFCEpkgQ8XDPRQ3yKDZ5qY9tKGSuHs+RnhMeAlx33Ng=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installShellCompletion --cmd sift --bash sift-completion.bash
  '';

  meta = with lib; {
    description = "A fast and powerful alternative to grep";
    homepage = "https://sift-tool.org";
    maintainers = with maintainers; [ viraptor ];
    license = licenses.gpl3;
  };
}
