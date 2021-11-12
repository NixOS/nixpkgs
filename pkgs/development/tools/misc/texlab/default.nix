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
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QLrmUlgrys+Bd2hiaPcfDUtn75XdaMhVThsDRq/ijQQ=";
  };

  cargoSha256 = "sha256-Xw0/vEL50vc9ktwjTz09160Fo7rXRVgeRo/EnWJ2PH0=";

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
