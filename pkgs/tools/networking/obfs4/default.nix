{ lib, buildGoModule, fetchFromGitLab, installShellFiles }:

buildGoModule rec {
  pname = "obfs4";
<<<<<<< HEAD
  version = "0.1.0";
=======
  version = "0.0.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
<<<<<<< HEAD
    # We don't use pname = lyrebird and we use the old obfs4 name as the first
    # will collide with lyrebird Gtk3 program.
    repo = "lyrebird";
    rev = "lyrebird-${version}";
    hash = "sha256-2qBSmAsaR3hfxuoR5U5UAFQAepUOEUnIGoxc/GZ5LmY=";
  };

  vendorHash = "sha256-O8CsvpwL9cfipl4M0BquSnG9tBrt/+i+i80OYk2mNiI=";
=======
    repo = "obfs4";
    rev = "obfs4proxy-${version}";
    sha256 = "sha256-/d1qub/mhEzzLQFytgAlhz8ukIC9d+GPK2Hfi3NMv+M=";
  };

  vendorHash = "sha256-7NF3yMouhjSM9SBNKHkeWV7qy0XTGnepEX28kBpbgdk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/obfs4proxy.1
<<<<<<< HEAD
    ln -s $out/share/man/man1/{obfs4proxy,lyrebird}.1
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

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
<<<<<<< HEAD
    homepage = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird";
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "lyrebird";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird/-/raw/${src.rev}/ChangeLog";
=======
    homepage = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/obfs4";
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "obfs4proxy";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/obfs4/-/raw/${src.rev}/ChangeLog";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with lib.licenses; [ bsd2 bsd3 gpl3 ];
  };
}
