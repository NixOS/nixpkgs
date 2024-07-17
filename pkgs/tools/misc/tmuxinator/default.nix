{
  lib,
  buildRubyGem,
  ruby,
  installShellFiles,
}:

# Cannot use bundleEnv because bundleEnv create stub with
# BUNDLE_FROZEN='1' environment variable set, which broke everything
# that rely on Bundler that runs under Tmuxinator.

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "tmuxinator";
  version = "3.1.2";
  source.sha256 = "t96v3RwBfezB644RVbTmO8i/xh1F23WQC8PBxc/msjg=";

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
    version = "1.3.0";
    source.sha256 = "sha256-Gtx/nls2VaaMcTk/7ovQrQiNFO6Og6C3NybyPLs8p8M=";
  };

  xdg = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "xdg";
    version = "2.2.5";
    source.sha256 = "04xr4cavnzxlk926pkji7b5yiqy4qsd3gdvv8mg6jliq6sczg9gk";
  };

  propagatedBuildInputs = [
    erubis
    thor
    xdg
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion $GEM_HOME/gems/${gemName}-${version}/completion/tmuxinator.{bash,zsh,fish}
  '';

  meta = with lib; {
    description = "Manage complex tmux sessions easily";
    homepage = "https://github.com/tmuxinator/tmuxinator";
    license = licenses.mit;
    maintainers = with maintainers; [
      auntie
      ericsagnes
    ];
    platforms = platforms.unix;
    mainProgram = "tmuxinator";
  };
}
