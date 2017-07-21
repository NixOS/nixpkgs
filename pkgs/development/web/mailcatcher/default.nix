{ stdenv, bundlerEnv, ruby, makeWrapper }:

stdenv.mkDerivation rec {
  name = "mailcatcher-${version}";

  version = (import ./gemset.nix).mailcatcher.version;

  env = bundlerEnv {
    name = "${name}-gems";

    inherit ruby;

    gemdir = ./.;
  };

  buildInputs = [ makeWrapper ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/mailcatcher $out/bin/mailcatcher
    makeWrapper ${env}/bin/catchmail $out/bin/catchmail
  '';

  meta = with stdenv.lib; {
    description = "SMTP server and web interface to locally test outbound emails";
    homepage    = https://mailcatcher.me/;
    license     = licenses.mit;
    maintainers = [ maintainers.zarelit ];
    platforms   = platforms.unix;
  };
}
