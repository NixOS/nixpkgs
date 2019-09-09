{ stdenv, fetchFromGitLab, rustPlatform, cmake, pkgconfig, openssl
, darwin

, x11Support ? stdenv.isLinux || stdenv.hostPlatform.isBSD
, xclip ? null, xsel ? null
, preferXsel ? false # if true and xsel is non-null, use it instead of xclip
}:

let
  usesX11 = stdenv.isLinux || stdenv.hostPlatform.isBSD;
in

assert (x11Support && usesX11) -> xclip != null || xsel != null;

with rustPlatform;

buildRustPackage rec {
  pname = "ffsend";
  version = "0.2.51";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "ffsend";
    rev = "v${version}";
    sha256 = "1ckzgzbv2fh5y7c5r0b9n6y2migmsrnlwdg7dybr0c82s39swr7f";
  };

  cargoSha256 = "1x4hxar60lwimldpsi0frdlssgsb72qahn3dmb980sj6cmbq3f0b";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices Security AppKit ])
  ;

  preBuild = stdenv.lib.optionalString (x11Support && usesX11) (
    if preferXsel && xsel != null then ''
      export XSEL_PATH="${xsel}/bin/xsel"
    '' else ''
      export XCLIP_PATH="${xclip}/bin/xclip"
    ''
  );

  postInstall = ''
    install -Dm644 contrib/completions/_ffsend "$out/share/zsh/site-functions/_ffsend"
    install -Dm644 contrib/completions/ffsend.bash "$out/share/bash-completion/completions/ffsend.bash"
    install -Dm644 contrib/completions/ffsend.fish "$out/share/fish/vendor_completions.d/ffsend.fish"
  '';
  # There's also .elv and .ps1 completion files but I don't know where to install those

  meta = with stdenv.lib; {
    description = "Easily and securely share files from the command line. A fully featured Firefox Send client";
    longDescription = ''
      Easily and securely share files and directories from the command line through a safe, private
      and encrypted link using a single simple command. Files are shared using the Send service and
      may be up to 2GB. Others are able to download these files with this tool, or through their
      web browser.
    '';
    homepage = https://gitlab.com/timvisee/ffsend;
    license = licenses.gpl3;
    maintainers = [ maintainers.lilyball ];
    platforms = platforms.unix;
  };
}
