{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, help2man
, installShellFiles
, libiconv
, Security
, CoreServices
, nix-update-script
}:

let
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = "texlab";
    rev = "refs/tags/v${version}";
    hash = "sha256-MTWaGgDIDo3CaRHyHWqliKsPdbU/TZPsyfF7SoHTnhk=";
  };

  cargoHash = "sha256-8Vrp4d5luf91pKpUC4wWn4otsanqopCHwCjcnfTzyLk=";

  outputs = [ "out" ] ++ lib.optional (!isCross) "man";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional (!isCross) help2man;

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
    CoreServices
  ];

  # When we cross compile we cannot run the output executable to
  # generate the man page
  postInstall = lib.optionalString (!isCross) ''
    # TexLab builds man page separately in CI:
    # https://github.com/latex-lsp/texlab/blob/v5.9.2/.github/workflows/publish.yml#L117-L121
    help2man --no-info "$out/bin/texlab" > texlab.1
    installManPage texlab.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://github.com/latex-lsp/texlab";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar kira-bruneau ];
    platforms = platforms.all;
  };
}
