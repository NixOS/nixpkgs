{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, libiconv
, Security, CoreServices, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HX1Mnzq+GsRnUsJERK5gPI5x4op885t+9Vn6vogSK1o=";
  };

  cargoSha256 = "sha256-AdzaLqwONI7WEcL8U0OGuyX/pg+BpZbJz9aaSClo47Q=";

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs =
    lib.optionals stdenv.isDarwin [ libiconv Security CoreServices ];

  postInstall = ''
    installManPage texlab.1

    # Remove generated dylib of html2md dependency. TexLab statically
    # links to the generated rlib and doesn't reference the dylib. I
    # couldn't find any way to prevent building this by passing cargo flags.
    # See https://gitlab.com/Kanedias/html2md/-/blob/0.2.10/Cargo.toml#L20
    rm "$out/lib/libhtml2md${stdenv.hostPlatform.extensions.sharedLibrary}"
    rmdir "$out/lib"
  '';

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://texlab.netlify.app";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar kira-bruneau ];
    platforms = platforms.all;
  };
}
