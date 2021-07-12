{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, libiconv
, Security
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iXsV7zt190GH0kTMpdmf8xHk4cqtCVwq6LDICmhe5qU=";
  };

  cargoHash = "sha256-Yqn6VpAKw93QvkxuwNcYvrQm0C4TfisRDcmFy95/yw8=";

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security CoreServices ];

  postInstall = ''
    installManPage texlab.1

    # Remove generated dylib of html2md dependency. TexLab statically
    # links to the generated rlib and doesn't reference the dylib. I
    # couldn't find any way to prevent building this by passing cargo flags.
    # See https://gitlab.com/Kanedias/html2md/-/blob/0.2.10/Cargo.toml#L20
    rm "$out/lib/libhtml2md${stdenv.hostPlatform.extensions.sharedLibrary}"
    rmdir "$out/lib"
  '';

  meta = with lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://texlab.netlify.app";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar kira-bruneau ];
    platforms = platforms.all;
  };
}
