{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.12";

  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/obfs4.git";
    rev = "a564bc3840bc788605e1a8155f4b95ce0d70c6db"; # not tagged
    sha256 = "0hqk540q94sh4wvm31jjcvpdklhf8r35in4yii7xnfn58a7amfkc";
  };

  vendorSha256 = "0yjanv5piygffpdfysviijl7cql2k0r05bsxnlj4hbamsriz9xqy";

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
