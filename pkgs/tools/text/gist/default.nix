{ buildRubyGem, lib, ruby, makeWrapper }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "gist";
  version = "4.5.0";
  sha256 = "0k9bgjdmnr14whmjx6c8d5ak1dpazirj96hk5ds69rl5d9issw0l";

  buildInputs = [ makeWrapper ];

  postInstall = ''
    # Fix the default ruby wrapper
    makeWrapper $out/${ruby.gemPath}/bin/gist $out/bin/gist \
      --set GEM_PATH $out/${ruby.gemPath}:${ruby}/${ruby.gemPath}
  '';

  dontStrip = true;

  meta = with lib; {
    description = "upload code to https://gist.github.com (or github enterprise)";
    homepage = "http://defunkt.io/gist/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = ruby.meta.platforms;
  };
}
