{ lib, stdenv, fetchFromGitHub, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "p910nd";
  version = "0.97";

  src = fetchFromGitHub {
    owner = "kenyapcomau";
    repo = "p910nd";
    rev = version;
    hash = "sha256-MM4o7d3L3XIRYWJ/KPM2OltlVfVA/BgMuyhJMm/BS3c=";
  };

  nativeBuildInputs = [ installShellFiles ];

  enableParallelBuilding = true;

  # instead of mucking around with the Makefile, just install the bits we need
  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin p910nd
    install -Dm444 -t $out/share/doc/p910nd *.md
    installManPage p910nd.?

    runHook postInstall
  '';

  meta = with lib; {
    description = "Small printer daemon passing jobs directly to the printer";
    longDescription = ''
      p910nd is a small printer daemon intended for diskless platforms that
      does not spool to disk but passes the job directly to the printer.
      Normally a lpr daemon on a spooling host connects to it with a TCP
      connection on port 910n (where n=0, 1, or 2 for lp0, 1 and 2
      respectively). p910nd is particularly useful for diskless platforms.
      Common Unix Printing System (CUPS) supports this protocol, it's called
      the AppSocket protocol and has the scheme socket://. LPRng also supports
      this protocol and the syntax is lp=remotehost%9100 in /etc/printcap.
    '';
    homepage = "https://github.com/kenyapcomau/p910nd";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
