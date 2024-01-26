{ stdenv
, fetchFromGitLab
, libmd
, coreutils
, lib
, testers
, donkey
}:

stdenv.mkDerivation rec {
  pname = "donkey";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "donkey";
    repo = "donkey";
    rev = "tags/release/${version}";
    hash = "sha256-2xgb9l0Eko39HJVROAWEIP3qLg5t/5h/rm2MoXoKnJI=";
  };
  sourceRoot = "${src.name}/src";

  buildInputs = [ libmd ];

  preInstall = ''
    # don't change the owner, use global permissions:
    export INSTALL_PROGRAM="${coreutils}/bin/install -m 555"
    export INSTALL_DATA="${coreutils}/bin/install -m 444"
  '';

  passthru.tests.version = testers.testVersion { package = donkey; };

  meta = with lib; {
    description = "An alternative for S/KEY's 'key' command";
    longDescription = ''
Donkey is an alternative for S/KEY's "key" command.  The new feature that
the original key doesn't have is print an entry for skeykeys as
follows;

    kazu 0099 al02004          115d83956f1089b6  Apr 26,1995 22:13:27

This means that donkey is also an alternative for "keyinit".  Since the
entry is printed to stdout (not to /etc/skeykeys), you can easily send
it to a remote operator by e-mail (with a PGP signature or something).
So, it is possible to initiate S/KEY without logging in from the console of
the host.

The name "Donkey" is an acronym of "Don't Key".
    '';
    homepage = "https://devel.ringlet.net/security/donkey";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raboof ];
    platforms = platforms.all;
  };
}
