{ stdenv, fetchFromGitLab, rustPlatform, cmake, pkgconfig, openssl
, darwin
}:

with rustPlatform;

buildRustPackage rec {
  pname = "ffsend";
  version = "0.2.37";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c2iihd9abri6019qyl78n7l86pbh7ahy7hp2ijdzhrlsjdanzcr";
  };

  cargoSha256 = "04gcsjjn3fnc5q0z6jbyd439x4hylyfl912245wmpjchm0k2k22b";

  # Note: On Linux, the clipboard feature requires `xclip` to be in the `PATH`. Ideally we'd
  # depend on `xclip` and patch the source to run `xclip` from the Nix store instead of from `PATH`.
  # However, as I use macOS and not Linux, I'm not inclined to maintain a patch like that, nor do I
  # have a means to test it. To that end, we'll just leave the clipboard feature enabled and
  # trust that users that want to copy links to their clipboard will install `xclip` into their
  # profile.

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices Security AppKit ])
  ;

  postInstall = ''
    install -DTm755 {contrib/completions,$out/share/zsh/site-functions}/_ffsend
    install -DTm755 {contrib/completions,$out/share/bash-completion/completions}/ffsend.bash
    install -DTm755 {contrib/completions,$out/etc/fish/completions}/ffsend.fish
  '';

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
