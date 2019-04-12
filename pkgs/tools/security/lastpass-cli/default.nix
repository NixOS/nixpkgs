{ stdenv, lib, fetchFromGitHub, asciidoc, cmake, docbook_xsl, pkgconfig
, bash-completion, openssl, curl, libxml2, libxslt }:

stdenv.mkDerivation rec {
  pname = "lastpass-cli";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = pname;
    rev = "v${version}";
    sha256 = "12qjqvqzi3pq7hrdpq59bcxqy6yj1mhx145g9rky1jm2ipzpfayq";
  };

  nativeBuildInputs = [ asciidoc cmake docbook_xsl pkgconfig ];

  buildInputs = [
    bash-completion curl openssl libxml2 libxslt
  ];

  enableParallelBuilding = true;

  installTargets = [ "install" "install-doc" ];

  postInstall = ''
    install -Dm644 -T ../contrib/lpass_zsh_completion $out/share/zsh/site-functions/_lpass
    install -Dm644 -T ../contrib/completions-lpass.fish $out/share/fish/vendor_completions.d/lpass.fish
  '';

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = "https://github.com/lastpass/lastpass-cli";
    license     = licenses.gpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
