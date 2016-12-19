{ buildRubyGem, lib, ruby_2_2 }:

buildRubyGem rec {
  ruby = ruby_2_2;
  name = "${gemName}-${version}";
  gemName = "flvtool2";
  version = "1.0.6";
  sha256 = "0xsla1061pi4ryh3jbvwsbs8qchprchbqjy7652g2g64v37i74qj";

  meta = {
    homepage = https://github.com/unnu/flvtool2;
    description = "A tool to manipulate Macromedia Flash Video files";
    platforms = ruby.meta.platforms;
  };
}
