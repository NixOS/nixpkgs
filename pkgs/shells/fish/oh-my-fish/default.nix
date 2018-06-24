{ stdenv, fetchFromGitHub, fish }:

stdenv.mkDerivation rec {
  version = "6";
  name = "oh-my-fish-${version}";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "oh-my-fish";
    rev = "v${version}";
    sha256 = "1fb8827hm1fngydnh3qkww7dy2p0sdzcvn0hzpg8czhazrl72kls";
  };

  buildInputs = [ fish ];

  installPhase = ''
  outdir=$out/share/oh-my-fish
  mkdir -p $outdir
  cp -r $src/* $outdir
  '';

  meta = with stdenv.lib; {
  description     = "The Fishshell Framework";
  longDescription = ''
  Oh My Fish provides core infrastructure to allow you to install
  packages which extend or modify the look of your shell.
  It's fast, extensible and easy to use.

  To copy the Oh My Fish configuration to your home directory, run:

    # make directories
    $ mkdir -p ~/.config/omf
    $ mkdir -p ~/.config/fish/conf.d

    $ cd ~/.config/omf && echo "stable" > channel && echo "default" > theme && echo "theme default" > bundle

    # set fish file
    $ cat > ~/.config/fish/conf.d/omf.fish <<EOF
    # Path to Oh My Fish install.
    set -gx OMF_PATH "$(nix-env -q --out-path oh-my-fish | cut -d' ' -f3)/share/oh-my-fish"
    # Load Oh My Fish configuration.
    source \$OMF_PATH/init.fish
    >EOF

    $ fish -c "omf install"
  '';
  homepage        = "https://github.com/oh-my-fish/oh-my-fish";
  license         = licenses.mit;
  platforms       = platforms.all;
  maintainers     = with maintainers; [ tycho01 ];
  };
}
