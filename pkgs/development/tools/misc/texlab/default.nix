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
in rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-za3TauhNoxGDphpY615EnTt46HpMgS+sYpBln/twefw=";
  };

  cargoSha256 = "sha256-wppaa3IGOqkFu/1CAp8g+PlPtMWm/7qNpPu0k4/mL3A=";

  outputs = [ "out" ] ++ lib.optional (!isCross) "man";

  nativeBuildInputs = [ installShellFiles ]
  ++ lib.optional (!isCross) help2man;

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
    CoreServices
  ];

  postInstall = ''
    # Remove generated dylib of human_name dependency. TexLab statically
    # links to the generated rlib and doesn't reference the dylib. I
    # couldn't find any way to prevent building this by passing cargo flags.
    # See https://github.com/djudd/human-name/blob/master/Cargo.toml#L43
    rm "$out/lib/libhuman_name${stdenv.hostPlatform.extensions.sharedLibrary}"
    rmdir "$out/lib"
  ''
  # When we cross compile we cannot run the output executable to
  # generate the man page
  + lib.optionalString (!isCross) ''
    # TexLab builds man page separately in CI:
    # https://github.com/latex-lsp/texlab/blob/v4.2.1/.github/workflows/publish.yml#L131-L135
    help2man --no-info "$out/bin/texlab" > texlab.1
    installManPage texlab.1
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
