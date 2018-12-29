{ buildRubyGem, lib, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "gist";
  version = "5.0.0";
  source.sha256 = "1i0a73mzcjv4mj5vjqwkrx815ydsppx3v812lxxd9mk2s7cj1vyd";

  meta = with lib; {
    description = "Upload code to https://gist.github.com (or github enterprise)";
    homepage = http://defunkt.io/gist/;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = ruby.meta.platforms;
  };
}
