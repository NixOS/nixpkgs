{ stdenv, lib, fetchFromGitHub, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "cpufetch";
  version = "0.94";

  src = fetchFromGitHub {
    owner  = "Dr-Noob";
    repo   = "cpufetch";
    rev    = "v${version}";
    sha256 = "1gncgkhqd8bnz254qa30yyl10qm28dwx6aif0dwrj38z5ql40ck9";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -Dm755 cpufetch   $out/bin/cpufetch
    install -Dm644 LICENSE    $out/share/licenses/cpufetch/LICENSE
    installManPage cpufetch.8

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simplistic yet fancy CPU architecture fetching tool";
    license = licenses.mit;
    homepage = "https://github.com/Dr-Noob/cpufetch";
    changelog = "https://github.com/Dr-Noob/cpufetch/releases/tag/v${version}";
    maintainers = with maintainers; [ devhell ];
  };
}
