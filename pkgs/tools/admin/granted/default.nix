{ bash
, buildGoModule
, fetchFromGitHub
, fish
, lib
, makeWrapper
, xdg-utils
}:

buildGoModule rec {
  pname = "granted";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "common-fate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m6cFAX8FMyv9H1IKm6meWu2yNEZz4g1Q+h2rRijYJsc=";
  };

  vendorSha256 =
    "sha256-8BPntTgd7QqO2T3vyWXC1z5yE/ovg3D3iilnislqV30=";

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

  postInstall = ''
    # Install shell script
    install -Dm755 $src/scripts/assume $out/bin/assume
    substituteInPlace $out/bin/assume \
      --replace /bin/bash ${bash}/bin/bash

    wrapProgram $out/bin/assume \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}

    # Install fish script
    install -Dm755 $src/scripts/assume.fish $out/share/assume.fish
    substituteInPlace $out/share/assume.fish \
      --replace /bin/fish ${fish}/bin/fish
  '';

  meta = with lib; {
    description = "The easiest way to access your cloud.";
    homepage = "https://github.com/common-fate/granted";
    changelog = "https://github.com/common-fate/granted/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
