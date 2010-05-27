{stdenv, fetchurl, openssh}:

stdenv.mkDerivation {
	name="autossh-1.4b";
	src = fetchurl {
		url = "http://www.harding.motd.ca/autossh/autossh-1.4b.tgz";
		md5 = "8f9aa006f6f69e912d3c2f504622d6f7";
	};
	buildInputs = [ openssh ];
	installPhase = ''
install -D -m755 autossh      $out/bin/autossh                          || return 1
install -D -m644 CHANGES      $out/share/doc/autossh/CHANGES            || return 1
install -D -m644 README       $out/share/doc/autossh/README             || return 1
install -D -m644 autossh.host $out/share/autossh/examples/autossh.host  || return 1
install -D -m644 rscreen      $out/share/autossh/examples/rscreen       || return 1
install -D -m644 autossh.1    $out/man/man1/autossh.1                   || return 1
	'';
	meta = {
		homepage = http://www.harding.motd.ca/autossh/;
		description = "Automatically restart SSH sessions and tunnels";
	};
}

