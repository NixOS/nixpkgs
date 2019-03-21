{ stdenv, fetchFromGitLab, rustPlatform, cmake, pkgconfig, openssl
, darwin

, x11Support ? stdenv.isLinux
, xclip ? null
}:

assert x11Support -> xclip != null;

with rustPlatform;

buildRustPackage rec {
  name = "ffsend-${version}";
  version = "0.2.38";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "ffsend";
    rev = "v${version}";
    sha256 = "1kxxcqyilbhzcsnddlf7ha3dd57qj82yvbb9jsssimnlcskx84hx";
  };

  cargoSha256 = "1qxvm2pz01na6nijdn0hlv5hxshiz3pfy6km7n9hjyakwi684a0l";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices Security AppKit ])
  ;

  preBuild = if x11Support then ''
    export XCLIP_PATH="${xclip}/bin/xclip"
  '' else null;

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
    platforms = platforms.darwin ++ platforms.linux;
  };
}
