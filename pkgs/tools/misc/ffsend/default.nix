{ lib, stdenv, fetchFromGitLab, rustPlatform, cmake, pkg-config, openssl
, installShellFiles
, CoreFoundation, CoreServices, Security, AppKit, libiconv

, x11Support ? stdenv.isLinux || stdenv.hostPlatform.isBSD
, xclip ? null, xsel ? null
, preferXsel ? false # if true and xsel is non-null, use it instead of xclip
}:

let
  usesX11 = stdenv.isLinux || stdenv.isBSD;
in

assert (x11Support && usesX11) -> xclip != null || xsel != null;

with rustPlatform;

buildRustPackage rec {
  pname = "ffsend";
  version = "0.2.74";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "ffsend";
    rev = "v${version}";
    sha256 = "0ia9agh0h9hp06ijmlgnw63n3xz2jajjw1maz27sawqp342x9vn5";
  };

  cargoSha256 = "0dl671sw3amny52a81bx7imh94dvi91dprwhcm1b0g40mjic45pw";

  nativeBuildInputs = [ cmake pkg-config installShellFiles ];
  buildInputs =
    if stdenv.isDarwin then [ libiconv CoreFoundation CoreServices Security AppKit ]
    else [ openssl ];

  preBuild = lib.optionalString (x11Support && usesX11) (
    if preferXsel && xsel != null then ''
      export XSEL_PATH="${xsel}/bin/xsel"
    '' else ''
      export XCLIP_PATH="${xclip}/bin/xclip"
    ''
  );

  postInstall = ''
    installShellCompletion contrib/completions/ffsend.{bash,fish} --zsh contrib/completions/_ffsend
  '';
  # There's also .elv and .ps1 completion files but I don't know where to install those

  meta = with lib; {
    description = "Easily and securely share files from the command line. A fully featured Firefox Send client";
    longDescription = ''
      Easily and securely share files and directories from the command line through a safe, private
      and encrypted link using a single simple command. Files are shared using the Send service and
      may be up to 2GB. Others are able to download these files with this tool, or through their
      web browser.
    '';
    homepage = "https://gitlab.com/timvisee/ffsend";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lilyball equirosa ];
    platforms = platforms.unix;
  };
}
