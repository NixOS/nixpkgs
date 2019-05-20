{ lib, buildRubyGem, ruby }:

# Cannot use bundleEnv because bundleEnv create stub with
# BUNDLE_FROZEN='1' environment variable set, which broke everything
# that rely on Bundler that runs under Tmuxinator.

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "tmuxinator";
  version = "1.1.0";
  source.sha256 = "9f4a4fd0242c82844f9af109d2c03b6870060d7e30603e6d9bd017aee5380ec0";

  erubis = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "erubis";
    version = "2.7.0";
    source.sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
  };

  thor = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "thor";
    version = "0.20.0";
    source.sha256 = "0nmqpyj642sk4g16nkbq6pj856adpv91lp4krwhqkh2iw63aszdl";
  };

  xdg = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "xdg";
    version = "2.2.3";
    source.sha256 = "1bn47fdbwxqbdvjcfg86i32hmwm36k0xl876kb85f5da5v84lzmq";
  };

  propagatedBuildInputs = [ erubis thor xdg ];

  meta = with lib; {
    description = "Manage complex tmux sessions easily";
    homepage    = https://github.com/tmuxinator/tmuxinator;
    license     = licenses.mit;
    maintainers = with maintainers; [ auntie ericsagnes ];
    platforms   = platforms.unix;
  };
}
