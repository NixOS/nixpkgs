{ runCommand, lib }:

runCommand "openbsd-compat"
  {
    include = ./include;

    meta = with lib; {
      description = "Header-only library for running OpenBSD software on Linux";
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ artemist ];
    };
  }
  ''
    mkdir -p $out
    cp -R $include $out/include
  ''
