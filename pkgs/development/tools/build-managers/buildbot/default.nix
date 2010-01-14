{ fetchurl, stdenv, buildPythonPackage, twisted, texinfo }:

buildPythonPackage (rec {
  name = "buildbot-0.7.11p3";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://sourceforge/buildbot/${name}.tar.gz";
    sha256 = "0h77ijf5iqvc8bnfxpsh3hvpr7wj23pkcywd3hcyphv1wwlhmhjv";
  };

  patchPhase =
    # The code insists on /usr/bin/tail, /usr/bin/make, etc.
    '' echo "patching erroneous absolute path references..."
       for i in $(find -name \*.py)
       do
         sed -i "$i" \
             -e "s|/usr/bin/python|$(type -P python)|g ; s|/usr/bin/||g"
       done
    '';

  buildInputs = [ texinfo ];
  propagatedBuildInputs = [ twisted ];

  # FIXME: Some tests fail.
  doCheck = false;

  postInstall =
    '' ensureDir "$out/share/info"
       make -C docs buildbot.info
       cp -v "docs/buildbot.info"* "$out/share/info"
    '';

  meta = {
    homepage = http://buildbot.net/;

    license = "GPLv2+";

    # Of course, we don't really need that on NixOS.  :-)
    description = "BuildBot, a system to automate the software compile/test cycle";

    longDescription =
      '' The BuildBot is a system to automate the compile/test cycle
         required by most software projects to validate code changes.  By
         automatically rebuilding and testing the tree each time something
         has changed, build problems are pinpointed quickly, before other
         developers are inconvenienced by the failure.  The guilty
         developer can be identified and harassed without human
         intervention.  By running the builds on a variety of platforms,
         developers who do not have the facilities to test their changes
         everywhere before checkin will at least know shortly afterwards
         whether they have broken the build or not.  Warning counts, lint
         checks, image size, compile time, and other build parameters can
         be tracked over time, are more visible, and are therefore easier
         to improve.

         The overall goal is to reduce tree breakage and provide a platform
         to run tests or code-quality checks that are too annoying or
         pedantic for any human to waste their time with.  Developers get
         immediate (and potentially public) feedback about their changes,
         encouraging them to be more careful about testing before checking
         in code.
      '';

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
})
