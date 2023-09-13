{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, asciidoc
, cmake
, docbook_xsl
, pkg-config
, bash-completion
, openssl
, curl
, libxml2
, libxslt
}:

stdenv.mkDerivation rec {
  pname = "lastpass-cli";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ntUBwZ0bVkkpvWK/jQBkLNpCYEDI14/ki0cLwYpEWXk=";
  };

  patches = [
    # Pull fix pending upstream inclusion for -fno-common toolchains:
    #   https://github.com/lastpass/lastpass-cli/pull/576
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/lastpass/lastpass-cli/commit/e3311cebdb29a3267843cf656a32f01c5062897e.patch";
      sha256 = "1yjx2p98nb3n8ywc9lhf2zal5fswawb5i6lgnicdin23zngff5l8";
    })
  ];

  nativeBuildInputs = [ asciidoc cmake docbook_xsl pkg-config ];

  buildInputs = [
    bash-completion
    curl
    openssl
    libxml2
    libxslt
  ];

  installTargets = [ "install" "install-doc" ];

  postInstall = ''
    install -Dm644 -T ../contrib/lpass_zsh_completion $out/share/zsh/site-functions/_lpass
    install -Dm644 -T ../contrib/completions-lpass.fish $out/share/fish/vendor_completions.d/lpass.fish
    install -Dm755 -T ../contrib/examples/git-credential-lastpass $out/bin/git-credential-lastpass
  '';

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage = "https://github.com/lastpass/lastpass-cli";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
