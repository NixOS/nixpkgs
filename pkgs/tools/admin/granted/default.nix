{
  bash,
  buildGoModule,
  fetchFromGitHub,

  withFish ? false,
  fish,

  lib,
  makeWrapper,
  xdg-utils,
}:

buildGoModule rec {
  pname = "granted";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "common-fate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+vJN91adsZNihyQNLFFKt94l37lynpGvFIGPvd/9/CM=";
  };

  vendorHash = "sha256-QoT7zfNbKDZyxGhDX1Lleu3mpTVXGKleX/b86l8nXXs=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/common-fate/granted/internal/build.Version=v${version}"
    "-X github.com/common-fate/granted/internal/build.Commit=${src.rev}"
    "-X github.com/common-fate/granted/internal/build.Date=1970-01-01-00:00:01"
    "-X github.com/common-fate/granted/internal/build.BuiltBy=Nix"
  ];

  subPackages = [
    "cmd/granted"
  ];

  postInstall =
    ''
      ln -s $out/bin/granted $out/bin/assumego

      # Install shell script
      install -Dm755 $src/scripts/assume $out/bin/assume
      substituteInPlace $out/bin/assume \
        --replace /bin/bash ${bash}/bin/bash

      wrapProgram $out/bin/assume \
        --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}

    ''
    + lib.optionalString withFish ''
      # Install fish script
      install -Dm755 $src/scripts/assume.fish $out/share/assume.fish
      substituteInPlace $out/share/assume.fish \
        --replace /bin/fish ${fish}/bin/fish
    '';

  meta = with lib; {
    description = "The easiest way to access your cloud";
    homepage = "https://github.com/common-fate/granted";
    changelog = "https://github.com/common-fate/granted/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
