{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  makeWrapper,
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.88.2";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    tag = "v${version}";
    hash = "sha256-p5vB9ug/H7xV7Y4GIk2BUUMFJ4/tcKj+V4qvYwCJlRU=";
  };

  vendorHash = "sha256-YsUAu2gEXzpjM/jg4VJ7KTvf1/cLTO04hLOLmUDeYk0=";

  nativeBuildInputs = [ makeWrapper ];

  proxyVendor = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=${version}"
  ];

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}

    wrapProgram $out/bin/trufflehog --add-flags --no-update
  '';

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [
      fab
      sarcasticadmin
    ];
  };
}
