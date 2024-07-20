{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "cpufetch";
  version = "1.05";

  src = fetchFromGitHub {
    owner = "Dr-Noob";
    repo = "cpufetch";
    rev = "v${version}";
    sha256 = "sha256-8g4nFV3PgYRagzUG7S2ifpuSaCCZ5HlwsjkQ+wdk4Yw=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -Dm755 cpufetch   $out/bin/cpufetch
    install -Dm644 LICENSE    $out/share/licenses/cpufetch/LICENSE
    installManPage cpufetch.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simplistic yet fancy CPU architecture fetching tool";
    license = licenses.gpl2Only;
    homepage = "https://github.com/Dr-Noob/cpufetch";
    changelog = "https://github.com/Dr-Noob/cpufetch/releases/tag/v${version}";
    maintainers = with maintainers; [ devhell ];
    mainProgram = "cpufetch";
  };
}
