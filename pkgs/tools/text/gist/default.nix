{ buildRubyGem, lib, ruby, makeWrapper }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "gist";
  version = "4.6.1";
  sha256 = "16qvmn7syvcf4lnblngzvq8xynvb62h1xhfc7xfb0c1sjh166hff";

  buildInputs = [ makeWrapper ];

  postInstall = ''
    # Fix the default ruby wrapper
    makeWrapper $out/${ruby.gemPath}/bin/gist $out/bin/gist \
      --set GEM_PATH $out/${ruby.gemPath}:${ruby}/${ruby.gemPath}
  '';

  dontStrip = true;

  meta = with lib; {
    description = "Upload code to https://gist.github.com (or github enterprise)";
    homepage = http://defunkt.io/gist/;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = ruby.meta.platforms;
  };
}
