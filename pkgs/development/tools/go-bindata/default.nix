{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "go-bindata";
  version = "3.24.0";

  src = fetchFromGitHub {
    owner = "kevinburke";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dEfD5oV2nXLVg+a7PlB6LqhEBosG7eTptqKKDWcQAss=";
  };

  vendorHash = null;

  patches = [
    # Add go modules support
    (fetchpatch {
      url = "https://github.com/kevinburke/go-bindata/commit/b5c6f880d411b9c24a8ae1c8b608ab80cb9aacb4.patch";
      hash = "sha256-dzzp5p+jdg09oo6jeSlms+MMMDWUXpsescj132MT6D8=";
    })
  ];

  subPackages = [ "go-bindata" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/kevinburke/go-bindata";
    changelog = "https://github.com/kevinburke/go-bindata/blob/v${version}/CHANGELOG.md";
    description = "A small utility which generates Go code from any file, useful for embedding binary data in a Go program";
    maintainers = with maintainers; [ cstrahan ];
    license = licenses.cc0;
  };
}
