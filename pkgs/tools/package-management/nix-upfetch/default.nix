{ stdenv, fetchFromGitHub, makeWrapper
, rustPlatform, pkgconfig, ncurses
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxml2, libxslt
, libredirect, coreutils, gawk, gnugrep, gnused, jq, nix, nix-prefetch }:

with stdenv.lib;

let
  nix-update-fetch = rustPlatform.buildRustPackage rec {
    name = "${pname}-${version}";
    pname = "nix-update-fetch";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "msteen";
      repo = "nix-update-fetch";
      rev = "bc201ec28be669f67501058e97b93e6a6e7b4e07";
      sha256 = "09qqk9wcbbnwv0rkmr18k4pvaf6xpbrfci7ki44v8m6p4pwvqczw";
    };

    RUSTC_BOOTSTRAP = 1;

    buildInputs = [ pkgconfig ncurses ];

    cargoSha256 = "0g2gmmhx2gcb02yqmzavx7fqyvdblgg16rhq10rw2slnrmsz84k6";

    meta = {
      description = "Update a call made to a fetcher function call and its surrounding bindings";
      homepage = https://github.com/msteen/nix-update-fetch;
      license = licenses.mit;
      maintainers = with maintainers; [ msteen ];
      platforms = platforms.all;
    };
  };

in stdenv.mkDerivation rec {
  pname = "nix-upfetch";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "msteen";
    repo = "nix-upfetch";
    rev = "223d785c1f2ee2ab6aeb964794aec78f9c160da5";
    sha256 = "001l19pw0aj3n3m16sbzvi214a2k0qqhph5y09vdndxbfsl8p43i";
  };

  nativeBuildInputs = [
    makeWrapper
    asciidoc docbook_xml_dtd_45 docbook_xsl libxml2 libxslt
  ];

  configurePhase = ''
    . configure.sh
  '';

  buildPhase = ''
    a2x -f manpage doc/nix-upfetch.1.asciidoc
  '';

  installPhase = ''
    lib=$out/lib/${pname}
    mkdir -p $lib
    substitute src/main.sh $lib/main.sh \
      --subst-var-by lib $lib \
      --subst-var-by libredirect ${libredirect} \
      --subst-var-by version '${version}'
    chmod +x $lib/main.sh
    patchShebangs $lib/main.sh
    cp lib/*.nix $lib/

    mkdir -p $out/bin
    makeWrapper $lib/main.sh $out/bin/${pname} \
      --prefix PATH : '${makeBinPath [ coreutils gawk gnugrep gnused jq nix nix-prefetch nix-update-fetch ]}'

    mkdir -p $out/bin
    cp src/prefetch.sh $lib/prefetch.sh
    chmod +x $lib/prefetch.sh
    patchShebangs $lib/prefetch.sh
    makeWrapper $lib/prefetch.sh $out/bin/nix-preupfetch \
      --prefix PATH : '${makeBinPath [ coreutils gnused ]}'

    mkdir -p $out/share/man/man1
    substitute doc/nix-upfetch.1 $out/share/man/man1/nix-upfetch.1 \
      --subst-var-by version '${version}' \
      --replace '01/01/1970' "$date"

    mkdir -p $out/share/bash-completion/completions
    substitute ${nix-prefetch}/share/bash-completion/completions/nix-prefetch $out/share/bash-completion/completions/nix-preupfetch \
      --replace 'complete -F _nix_prefetch nix-prefetch' 'complete -F _nix_prefetch nix-preupfetch'
    mkdir -p $out/share/zsh/site-functions
    substitute ${nix-prefetch}/share/zsh/site-functions/_nix_prefetch $out/share/zsh/site-functions/_nixpkg_prefetch \
      --replace '#compdef nix-prefetch' '#compdef nix-preupfetch'
  '';

  meta = {
    description = "Update any fetcher call that can be prefetched with nix-prefetch";
    homepage = https://github.com/msteen/nix-upfetch;
    license = licenses.mit;
    maintainers = with maintainers; [ msteen ];
    platforms = platforms.all;
  };
}
