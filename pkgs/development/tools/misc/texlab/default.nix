{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, libiconv
, Security
, CoreServices
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oYM+OAYjQ8aNAryg0Cthj14BsxMFnOtz38XdUQZZolk=";
  };

  cargoSha256 = "sha256-TDGiqC9eNIJfLTc1R3nvE84rAsVE8jtTaeQbVNMeVgg=";

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security CoreServices ];

  postInstall = ''
    installManPage texlab.1

    # Remove generated dylib of human_name dependency. TexLab statically
    # links to the generated rlib and doesn't reference the dylib. I
    # couldn't find any way to prevent building this by passing cargo flags.
    # See https://github.com/djudd/human-name/blob/master/Cargo.toml#L43
    rm "$out/lib/libhuman_name${stdenv.hostPlatform.extensions.sharedLibrary}"
    rmdir "$out/lib"
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://texlab.netlify.app";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar kira-bruneau ];
    platforms = platforms.all;
  };
}
