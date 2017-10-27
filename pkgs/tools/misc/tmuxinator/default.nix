{ lib, buildRubyGem, makeWrapper, ruby }:

# Cannot use bundleEnv because bundleEnv create stub with
# BUNDLE_FROZEN='1' environment variable set, which broke everything
# that rely on Bundler that runs under Tmuxinator.

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "tmuxinator";
  version = "0.10.0";
  sha256 = "199pq15qknpcafw8ryb9kk1jsrwnncg6k5l9d4n0nmms4knxlqlf";

  erubis = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "erubis";
    version = "2.7.0";
    sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
  };

  thor = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "thor";
    version = "0.19.1";
    sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
  };

  xdg = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "xdg";
    version = "2.2.3";
    sha256 = "1bn47fdbwxqbdvjcfg86i32hmwm36k0xl876kb85f5da5v84lzmq";
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
