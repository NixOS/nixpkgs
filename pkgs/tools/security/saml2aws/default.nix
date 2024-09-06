{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  AppKit,
}:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.17";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-2bt/AUcXwXf1TxPesfXSyoiBeLHx+LGgDk4xbXEAcaY=";
  };

  vendorHash = "sha256-gtl8T8wXnpLgDZc6qSgFKpA+XbcLNHf20ieBkyNdE+s=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  subPackages = [
    "."
    "cmd/saml2aws"
  ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd saml2aws \
      --bash <($out/bin/saml2aws --completion-script-bash) \
      --zsh <($out/bin/saml2aws --completion-script-zsh)
  '';

  meta = with lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    mainProgram = "saml2aws";
    homepage = "https://github.com/Versent/saml2aws";
    license = licenses.mit;
    maintainers = [ lib.maintainers.pmyjavec ];
  };
}
