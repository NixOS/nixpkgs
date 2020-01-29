{ lib, buildRubyGem, ruby }:

# Cannot use bundleEnv because bundleEnv create stub with
# BUNDLE_FROZEN='1' environment variable set, which broke everything
# that rely on Bundler that runs under Tmuxinator.

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "tmuxinator";
  version = "1.1.4";
  source.sha256 = "06ajfvsmq2040b7nk2ifih3sqxgwzih5j1d25nh4ilgjlrfmha98";

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
    version = "1.0.1";
    source.sha256 = "1xbhkmyhlxwzshaqa7swy2bx6vd64mm0wrr8g3jywvxy7hg0cwkm";
  };

  xdg = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "xdg";
    version = "2.2.5";
    source.sha256 = "04xr4cavnzxlk926pkji7b5yiqy4qsd3gdvv8mg6jliq6sczg9gk";
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
