{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  IOKit,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gotop";
  version = "4.2.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = "gotop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W7a3QnSIR95N88RqU2sr6oEDSqOXVfAwacPvS219+1Y=";
  };

  proxyVendor = true;
  vendorHash = "sha256-KLeVSrPDS1lKsKFemRmgxT6Pxack3X3B/btSCOUSUFY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ IOKit ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  postInstall = ''
    $out/bin/gotop --create-manpage > gotop.1
    installManPage gotop.1
  '';

  meta = with lib; {
    description = "Terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    changelog = "https://github.com/xxxserxxx/gotop/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    mainProgram = "gotop";
  };
})
