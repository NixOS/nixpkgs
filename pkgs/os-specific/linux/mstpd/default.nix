{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mstpd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-m4gbVXAPIYGQvTFaSziFuOO6say5kgUsk7NSdqXgKmA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--prefix=$(out)"
    "--sysconfdir=$(out)/etc"
    "--sbindir=$(out)/bin"
    "--libexecdir=$(out)/lib"
    "--with-bashcompletiondir=$(out)/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Multiple Spanning Tree Protocol daemon";
    homepage = "https://github.com/mstpd/mstpd";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kamillaova ];
    platforms = platforms.linux;
  };
}
