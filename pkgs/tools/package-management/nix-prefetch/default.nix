{ lib, stdenv, fetchFromGitHub, installShellFiles, makeWrapper, asciidoc
, docbook_xml_dtd_45, git, docbook_xsl, libxml2, libxslt, coreutils, gawk
, gnugrep, gnused, jq, nix }:

let
  binPath = lib.makeBinPath [ coreutils gawk git gnugrep gnused jq nix ];

in stdenv.mkDerivation rec {
  pname = "nix-prefetch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "msteen";
    repo = "nix-prefetch";
    rev = version;
    sha256 = "11792677zyi06jw641xi9aywwgh9002b8406w6qids212c14va6n";
    # the stat call has to be in a subshell or we get the current date
    extraPostFetch = ''
      echo $(stat -c %Y $out) > $out/.timestamp
    '';
  };

  postPatch = ''
    lib=$out/lib/${pname}

    substituteInPlace doc/nix-prefetch.1.asciidoc \
      --subst-var-by version $version

    substituteInPlace src/main.sh \
      --subst-var-by lib $lib \
      --subst-var-by version $version

    substituteInPlace src/tests.sh \
      --subst-var-by bin $out/bin
  '';

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    installShellFiles
    libxml2
    libxslt
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    a2x -a revdate=$(date --utc --date=@$(cat $src/.timestamp) +%d/%m/%Y) \
      -f manpage doc/nix-prefetch.1.asciidoc
  '';

  installPhase = ''
    install -Dm555 -t $lib src/*.sh
    install -Dm444 -t $lib lib/*
    makeWrapper $lib/main.sh $out/bin/${pname} \
      --prefix PATH : ${binPath}

    installManPage doc/nix-prefetch.?

    installShellCompletion --name ${pname} contrib/nix-prefetch-completion.{bash,zsh}

    mkdir -p $out/share/doc/${pname}/contrib
    cp -r contrib/hello_rs $out/share/doc/${pname}/contrib
  '';

  meta = with lib; {
    description = "Prefetch any fetcher function call, e.g. package sources";
    license = licenses.mit;
    maintainers = with maintainers; [ msteen ];
    inherit (src.meta) homepage;
  };
}
