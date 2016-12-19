{ stdenv, lib, bundlerEnv, ruby_2_2, curl }:

bundlerEnv rec {
  pname = "asciidoctor";
  ruby = ruby_2_2;
  gemdir = ./.;

  meta = with lib; {
    description = "A faster Asciidoc processor written in Ruby";
    homepage = http://asciidoctor.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ gpyh ];
    platforms = platforms.unix;
  };
}
