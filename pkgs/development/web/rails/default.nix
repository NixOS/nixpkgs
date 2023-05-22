# This derivation makes rails executable available in your path. However, it is
# still advisable to manage the generated application Gemfile through
# [bundix](https://github.com/nix-community/bundix).
#
# For this reason, you should run `rails new` with `--skip-bundle` and
# `--skip-webpack-install` (which relies on bundle being executed) options. E.g.:
#
# ```
# rails new --skip-bundle --skip-webpack-install rails_app
# ```
#
# Then, in order to run bundle:
#
# ```
# cd rails_app
# nix-shell -p bundix --run 'bundix -l'
# ```
#
# You can generate a default shell for your project and enter it:
#
# ```
# nix-shell -p bundix --run 'bundix -i'
# nix-shell
# ```
#
# Keep in mind that in the case your nee to run `rails webpacker:install` you
# need to add `nodejs` and `yarn` to the `buildInputs` attribute of generated
# `shell.nix` file. 
{ lib, bundlerEnv }:

bundlerEnv rec {
  name = "rails-${version}";

  version = (import ./gemset.nix).rails.version;
  gemdir = ./.;

  meta = with lib; {
    description = "Ruby web application development framework";
    longDescription = '';
      Ruby on Rails is a full-stack web framework optimized for programmer
      happiness and sustainable productivity. It encourages beautiful code by
      favoring convention over configuration.
    '';
    homepage = https://rubyonrails.org;
    license = licenses.mit;
    maintainers = with maintainers; [ waiting-for-dev ];
    platforms = platforms.unix;
  };
}
