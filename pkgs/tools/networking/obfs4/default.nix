{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.14";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "obfs4";
    rev = "obfs4proxy-${version}";
    sha256 = "sha256-/d1qub/mhEzzLQFytgAlhz8ukIC9d+GPK2Hfi3NMv+M=";
  };

  vendorHash = "sha256-7NF3yMouhjSM9SBNKHkeWV7qy0XTGnepEX28kBpbgdk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Circumvents censorship by transforming Tor traffic between clients and bridges";
    longDescription = ''
      Obfs4proxy is a tool that attempts to circumvent censorship by
      transforming the Tor traffic between the client and the bridge.
      This way censors, who usually monitor traffic between the client
      and the bridge, will see innocent-looking transformed traffic
      instead of the actual Tor traffic.  obfs4proxy implements the
      obfsucation protocols obfs2, obfs3, and obfs4.  It is written in
      Go and is compliant with the Tor pluggable transports
      specification, and its modular architecture allows it to support
      multiple pluggable transports.
    '';
    homepage = "https://www.torproject.org/projects/obfsproxy";
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "obfs4proxy";
    changelog = "https://gitweb.torproject.org/pluggable-transports/obfs4.git/plain/ChangeLog";
    downloadPage = "https://gitweb.torproject.org/pluggable-transports/obfs4.git/";
    license = with lib.licenses; [ bsd2 bsd3 gpl3 ];
  };
}
