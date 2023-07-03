{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, sqlite
, installShellFiles
, Security
, libiconv
, innernet
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "innernet";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = "innernet";
    rev = "refs/tags/v${version}";
    hash = "sha256-eAiYXE8kSfuhBgrIo6rbtE2YH9JcLJwA/vXA5IWNYG8=";
  };

  cargoHash = "sha256-F+VvVF+5I53IF4Vur0SkUQXoqo8EE3XWirm88gu/GI4=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    libiconv
  ];

  postInstall = ''
    installManPage doc/innernet-server.8.gz
    installManPage doc/innernet.8.gz
    installShellCompletion doc/innernet.completions.{bash,fish,zsh}
    installShellCompletion doc/innernet-server.completions.{bash,fish,zsh}
  '' + (lib.optionalString stdenv.isLinux ''
    find . -regex '.*\.\(target\|service\)' | xargs install -Dt $out/lib/systemd/system
    find $out/lib/systemd/system -type f | xargs sed -i "s|/usr/bin/innernet|$out/bin/innernet|"
  '');

  passthru.tests = {
    serverVersion = testers.testVersion { package = innernet; command = "innernet-server --version"; };
    version = testers.testVersion { package = innernet; command = "innernet --version"; };
  };

  meta = with lib; {
    description = "A private network system that uses WireGuard under the hood";
    homepage = "https://github.com/tonarino/innernet";
    changelog = "https://github.com/tonarino/innernet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek _0x4A6F ];
  };
}
