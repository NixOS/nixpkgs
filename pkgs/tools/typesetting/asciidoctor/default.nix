{ stdenv, lib, bundlerEnv, ruby_2_2, curl }:

bundlerEnv rec {
  name = "asciidoctor-${version}";
  version = "1.5.4";

  ruby = ruby_2_2;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  # Delete dependencies' executables
  postBuild = ''
    find $out/bin -type f -not -wholename '*bin/asciidoctor*' -print0 \
    | xargs -0 rm
  '';

  meta = with lib; {
    description = "A faster Asciidoc processor written in Ruby";
    homepage = http://asciidoctor.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ gpyh ];
    platforms = platforms.unix;
  };
}
