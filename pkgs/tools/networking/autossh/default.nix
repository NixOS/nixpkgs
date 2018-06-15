{stdenv, fetchurl, openssh}:

stdenv.mkDerivation rec {
  name = "autossh-1.4f";
  
  src = fetchurl {
    url = "http://www.harding.motd.ca/autossh/${name}.tgz";
    sha256 = "1wpqwa2872nqgqbhnb6nnkrlzpdawd5k69gh1qp68354pvhyawh1";
  };
  
  buildInputs = [ openssh ];
  
  installPhase =
    ''
      install -D -m755 autossh      $out/bin/autossh                          || return 1
      install -D -m644 CHANGES      $out/share/doc/autossh/CHANGES            || return 1
      install -D -m644 README       $out/share/doc/autossh/README             || return 1
      install -D -m644 autossh.host $out/share/autossh/examples/autossh.host  || return 1
      install -D -m644 rscreen      $out/share/autossh/examples/rscreen       || return 1
      install -D -m644 autossh.1    $out/man/man1/autossh.1                   || return 1
    '';
    
  meta = with stdenv.lib; {
    homepage = http://www.harding.motd.ca/autossh/;
    description = "Automatically restart SSH sessions and tunnels";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
