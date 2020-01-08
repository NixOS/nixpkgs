{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.1.3";
  source.sha256 = "1lp5l2n4npd4hbgwgvib5a7l31jclg9qw55fl7nh650jhmb9m6lv";
}
