{ lib
, buildGoModule
, fetchFromGitLab
, nix
, makeWrapper
}:

buildGoModule rec {
  pname = "nc4nix";
  version = "unstable-2022-11-13";

  src = fetchFromGitLab {
    domain = "git.project-insanity.org";
    owner = "onny";
    repo = "nc4nix";
    rev = "857e789287692e42f3fcaae039d6f323b383543b";
    sha256 = "sha256-ekuvqTyoaYiNju4yiQLPmxaXaGD4T3Wv9A8CHY1MZOI=";
  };

  vendorSha256 = "sha256-uhINWxFny/OY7M2vV3ehFzP90J6Z8cn5IZHWOuEg91M=";

 nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    # Depends on nix-prefetch-url
    wrapProgram $out/bin/nc4nix \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = with lib; {
    description = "Packaging helper for Nextcloud apps";
    homepage = "https://git.project-insanity.org/onny/nc4nix";
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}

