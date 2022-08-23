{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, nix-prefetch-git
, go
}:

buildGoModule {
  pname = "vgo2nix";
  version = "unstable-2020-11-07";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "vgo2nix";
    rev = "4546d8056ab09ece3d2489594627c0541b15a397";
    sha256 = "0n9pf0i5y59kiiv6dq8h8w1plaz9w6s67rqr2acqgxa45iq36mkh";
  };

  vendorSha256 = "sha256-e5n0QhgffzC1igZX1zS18IX5oF5F0Zy/s8jWyNOD8NM=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  allowGoReference = true;

  postInstall = ''
    wrapProgram $out/bin/vgo2nix --prefix PATH : ${lib.makeBinPath [ nix-prefetch-git go ]}
  '';

  meta = with lib; {
    description = "Convert go.mod files to nixpkgs buildGoPackage compatible deps.nix files";
    homepage = "https://github.com/nix-community/vgo2nix";
    license = licenses.mit;
    maintainers = with maintainers; [ adisbladis ];
    mainProgram = "vgo2nix";
  };
}
