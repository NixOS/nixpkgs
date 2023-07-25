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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "common-fate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/mSefgkRNhKahToUOZQ73TYERq2mV23u+M8DSJL8E4Y=";
  };

  vendorHash = "sha256-SGm5jJ8savjUqgeK5wQ9dxz9BgROkKrnrSwNcojC9gE=";

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
