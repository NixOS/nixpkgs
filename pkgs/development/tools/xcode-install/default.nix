{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "xcode-install";
  gemdir = ./.;
  exes = [ "xcversion" ];

  meta = {
    description = "Install and update your Xcodes automatically";
    homepage = "https://github.com/xcpretty/xcode-install";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ q3k ];
    license = with lib.licenses; [ mit ];
  };
}
