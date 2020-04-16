{ stdenv, lib, fetchFromGitHub, makeWrapper, asciidoc, docbook_xml_dtd_45, git
, docbook_xsl, libxml2, libxslt, coreutils, gawk, gnugrep, gnused, jq, nix
, installShellFiles }:

let binPath = lib.makeBinPath [ coreutils gawk git gnugrep gnused jq nix ];

in stdenv.mkDerivation rec {
  pname = "nix-prefetch";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "msteen";
    repo = "nix-prefetch";
    rev = version;
    sha256 = "0sf910b1m8q6429pyxlvmmgylha9f2a1s3sq3vgqdnb1dparl34r";
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
    a2x -f manpage doc/nix-prefetch.1.asciidoc
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

  meta = with stdenv.lib; {
    description = "Prefetch any fetcher function call, e.g. package sources";
    license = licenses.mit;
    maintainers = with maintainers; [ msteen ];
    inherit (src.meta) homepage;
  };
}
