{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, DiskArbitration
, Foundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fnm";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gazpjsGC5qEVeSqN+SleWWmr44CxJAJGqRNoQB38hjI=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation Security ];

  cargoSha256 = "sha256-mgBi0O7sqS0XtNM++S6fDjDoJSFVCr0wWYfzkAdQspw=";

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd fnm \
      --bash <($out/bin/fnm completions --shell bash) \
      --fish <($out/bin/fnm completions --shell fish) \
      --zsh <($out/bin/fnm completions --shell zsh)
  '';

  meta = with lib; {
    description = "Fast and simple Node.js version manager";
    homepage = "https://github.com/Schniz/fnm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kidonng ];
  };
}
