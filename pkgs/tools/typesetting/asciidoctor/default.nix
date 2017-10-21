{ stdenv, lib, bundlerEnv, ruby, curl }:

bundlerEnv {
  pname = "asciidoctor";

  inherit ruby;

  gemdir = ./.;

  meta = with lib; {
    description = "A faster Asciidoc processor written in Ruby";
    homepage = http://asciidoctor.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ gpyh ];
    platforms = platforms.unix;
  };
}
