{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
  installShellFiles,
  Security,
  libiconv,
  innernet,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "innernet";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = "innernet";
    rev = "refs/tags/v${version}";
    hash = "sha256-dFMAzLvPO5xAfJqUXdiLf13uh5H5ay+CI9aop7Fhprk=";
  };

  cargoHash = "sha256-39LryfisVtNMX2XLPh/AEQ1KzVtwdE3wuTaTbxGMaBI=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs =
    [
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      libiconv
    ];

  postInstall =
    ''
      installManPage doc/innernet-server.8.gz
      installManPage doc/innernet.8.gz
      installShellCompletion doc/innernet.completions.{bash,fish,zsh}
      installShellCompletion doc/innernet-server.completions.{bash,fish,zsh}
    ''
    + (lib.optionalString stdenv.hostPlatform.isLinux ''
      find . -regex '.*\.\(target\|service\)' | xargs install -Dt $out/lib/systemd/system
      find $out/lib/systemd/system -type f | xargs sed -i "s|/usr/bin/innernet|$out/bin/innernet|"
    '');

  passthru.tests = {
    serverVersion = testers.testVersion {
      package = innernet;
      command = "innernet-server --version";
    };
    version = testers.testVersion {
      package = innernet;
      command = "innernet --version";
    };
  };

  meta = with lib; {
    description = "Private network system that uses WireGuard under the hood";
    homepage = "https://github.com/tonarino/innernet";
    changelog = "https://github.com/tonarino/innernet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      tomberek
      _0x4A6F
    ];
  };
}
