{ stdenv, fetchFromGitHub, installShellFiles, makeWrapper, asciidoc
, docbook_xml_dtd_45, git, docbook_xsl, libxml2, libxslt, coreutils, gawk
, gnugrep, gnused, jq, nix, fetchpatch }:

let
  binPath = stdenv.lib.makeBinPath [ coreutils gawk git gnugrep gnused jq nix ];

in stdenv.mkDerivation rec {
  pname = "nix-prefetch";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "msteen";
    repo = "nix-prefetch";
    rev = version;
    sha256 = "15h6f743nn6sdq8l771sjxh92cyzqznkcs7szrc7nm066xvx8rd4";
    # the stat call has to be in a subshell or we get the current date
    extraPostFetch = ''
      echo $(stat -c %Y $out) > $out/.timestamp
    '';
  };

  patches = [
    # Fix compatibility with nixUnstable
    # https://github.com/msteen/nix-prefetch/pull/9
    (fetchpatch {
      url = "https://github.com/msteen/nix-prefetch/commit/2722cda48ab3f4795105578599b29fc99518eff4.patch";
      sha256 = "037m388sbl72kyqnk86mw7lhjhj9gzfglw3ri398ncfmmkq8b7r4";
    })
    # https://github.com/msteen/nix-prefetch/pull/12
    (fetchpatch {
      url = "https://github.com/msteen/nix-prefetch/commit/de96564e9f28df82bccd0584953094e7dbe87e20.patch";
      sha256 = "0mxai6w8cfs7k8wfbsrpg5hwkyb0fj143nm0v142am0ky8ahn0d9";
    })
  ];

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

  meta = with stdenv.lib; {
    description = "Prefetch any fetcher function call, e.g. package sources";
    license = licenses.mit;
    maintainers = with maintainers; [ msteen ];
    inherit (src.meta) homepage;
  };
}
