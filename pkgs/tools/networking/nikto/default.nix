{ lib
, stdenv
, fetchFromGitHub
, perlPackages
, makeWrapper
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "nikto";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "sullo";
    repo = "nikto";
    rev = "c83d0461edd75c02677dea53da2896644f35ecab";
    sha256 = "0vwq2zdxir67cn78ls11qf1smd54nppy266v7ajm5rqdc47q7fy2";
  };

  # Nikto searches its configuration file based on its current path
  # This fixes the current path regex for the wrapped executable.
  patches = [ ./NIKTODIR-nix-wrapper-fix.patch ];

  postPatch = ''
    # EXECDIR needs to be changed to the path where we copy the programs stuff
    # Forcing SSLeay is needed for SSL support (the auto mode doesn't seem to work otherwise)
    substituteInPlace program/nikto.conf.default \
      --replace "# EXECDIR=/opt/nikto" "EXECDIR=$out/share" \
      --replace "LW_SSL_ENGINE=auto" "LW_SSL_ENGINE=SSLeay"
  '';

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  propagatedBuildInputs = [ perlPackages.NetSSLeay ];

  buildInputs = [
    perlPackages.perl
  ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share"
    cp -a program/* "$out/share"
    install -Dm 755 "program/nikto.pl" "$out/bin/nikto"
    install -Dm 644 program/nikto.conf.default "$out/etc/nikto.conf"
    installManPage documentation/nikto.1
    install -Dm 644 program/docs/nikto_manual.html "$out/share/doc/${pname}/manual.html"
    install -Dm 644 README.md "$out/share/doc/${pname}/README"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/nikto \
      --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with lib; {
    description = "Web server scanner";
    license = licenses.gpl2Plus;
    homepage = "https://cirt.net/Nikto2";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.unix;
  };
}
