{ buildRubyGem, lib, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "gist";
  version = "5.1.0";
  source.sha256 = "0s69y6hi5iq5k6317j1kjmhi3mk586j1543q8wa608grwcmbq3fw";

  meta = with lib; {
    description = "Upload code to https://gist.github.com (or github enterprise)";
    homepage = http://defunkt.io/gist/;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = ruby.meta.platforms;
  };
}
