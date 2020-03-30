{ lib, bundlerApp, bundlerUpdateScript, defaultGemConfig }:
bundlerApp {
  pname = "ruby-debug-ide";
  gemdir = ./.;
  exes = ["rdebug-ide" "gdb_wrapper"];

  passthru.updateScript = bundlerUpdateScript "ruby-debug-ide";

  meta = with lib; {
    description = "An interface which glues ruby-debug to IDEs like Eclipse (RDT), NetBeans and RubyMine.";
    homepage = https://github.com/ruby-debug/ruby-debug-ide;
    license = licenses.mit;
  };

  gemConfig = defaultGemConfig // {
    ruby-debug-ide = attrs: {
      dontBuild = false;
      # patches = [
      #   ./0001-disable-extension.patch
      # ];
      postUnpack = ''
        echo "Overriding mkrf_conf.rb"
        echo '\
          # create dummy rakefile to indicate success
          f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
          f.write("task :default\n")
          f.close
        ' > $sourceRoot/ext/mkrf_conf.rb
      '';
    };
  };
}
