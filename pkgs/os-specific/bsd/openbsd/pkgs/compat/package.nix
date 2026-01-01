{ runCommand, lib }:

runCommand "openbsd-compat"
  {
    include = ./include;

<<<<<<< HEAD
    meta = {
=======
    meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      description = "Header-only library for running OpenBSD software on Linux";
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ artemist ];
    };
  }
  ''
    mkdir -p $out
    cp -R $include $out/include
  ''
