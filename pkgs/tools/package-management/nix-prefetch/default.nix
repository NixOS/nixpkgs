{ stdenv, fetchFromGitHub, makeWrapper
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxml2, libxslt
, coreutils, gawk, gnugrep, gnused, jq, nix }:

stdenv.mkDerivation rec {
  pname = "nix-prefetch";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "msteen";
    repo = "nix-prefetch";
    rev = version;
    sha256 = "0b9gdi7xzmfq0j258x724xsll8gi31m0m4pzfjkqinlm6zwr3sgm";
  };

  nativeBuildInputs = [
    makeWrapper
    asciidoc docbook_xml_dtd_45 docbook_xsl libxml2 libxslt
  ];

  configurePhase = ''
    . configure.sh
  '';

  buildPhase = ''
    a2x -f manpage doc/nix-prefetch.1.asciidoc
  '';

  installPhase = ''
    lib=$out/lib/${pname}
    mkdir -p $lib
    substitute src/main.sh $lib/main.sh \
      --subst-var-by lib $lib \
      --subst-var-by version '${version}'
    chmod +x $lib/main.sh
    patchShebangs $lib/main.sh
    cp lib/*.nix $lib/

    mkdir -p $out/bin
    makeWrapper $lib/main.sh $out/bin/${pname} \
      --prefix PATH : '${stdenv.lib.makeBinPath [ coreutils gawk gnugrep gnused jq nix ]}'

    substitute src/tests.sh $lib/tests.sh \
      --subst-var-by bin $out/bin
    chmod +x $lib/tests.sh
    patchShebangs $lib/tests.sh

    mkdir -p $out/share/man/man1
    substitute doc/nix-prefetch.1 $out/share/man/man1/nix-prefetch.1 \
      --subst-var-by version '${version}' \
      --replace '01/01/1970' "$date"

    install -D contrib/nix-prefetch-completion.bash $out/share/bash-completion/completions/nix-prefetch
    install -D contrib/nix-prefetch-completion.zsh $out/share/zsh/site-functions/_nix_prefetch

    mkdir -p $out/share/doc/${pname}/contrib
    cp -r contrib/hello_rs $out/share/doc/${pname}/contrib/
  '';

  meta = with stdenv.lib; {
    description = "Prefetch any fetcher function call, e.g. package sources";
    homepage = "https://github.com/msteen/nix-prefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ msteen ];
    platforms = platforms.all;
  };
}
