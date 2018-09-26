{buildVersion, x64sha256}:

{ fetchurl, stdenv, glib, xorg, cairo, gtk2, pango, makeWrapper, openssl, bzip2,
  pkexecPath ? "/run/wrappers/bin/pkexec", libredirect,
  gksuSupport ? false, gksu, unzip, zip, bash}:

assert gksuSupport -> gksu != null;

let

  libPath = stdenv.lib.makeLibraryPath [glib xorg.libX11 gtk2 cairo pango];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" ]
    ++ stdenv.lib.optional gksuSupport "/usr/bin/gksudo=${gksu}/bin/gksudo";
in let

  # package with just the binaries
  sublimeMerge = stdenv.mkDerivation {
    name = "sublimeMerge-${buildVersion}-bin";
    src =
      fetchurl {
        name = "sublime_merge_${buildVersion}_x64.tar.xz";
        url = "https://download.sublimetext.com/sublime_merge_build_${buildVersion}_x64.tar.xz";
        sha256 = x64sha256;
      };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [ makeWrapper zip unzip ];

    buildPhase = ''
      for i in crash_reporter git-credential-sublime ssh-askpass-sublime  sublime_merge; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
          $i
      done

      # Rewrite pkexec|gksudo argument. Note that we can't delete bytes in binary.
      sed -i -e 's,/bin/cp\x00,cp\x00\x00\x00\x00\x00\x00,g' sublime_merge
    '';

    installPhase = ''
      # Correct sublime_merge.desktop to exec `sublime' instead of /opt/sublime_merge
      sed -e "s,/opt/sublime_merge/sublime_merge,$out/sublime_merge," -i sublime_merge.desktop

      mkdir -p $out
      cp -prvd * $out/

      # We can't just call /usr/bin/env bash because a relocation error occurs
      # when trying to run a build from within Sublime Merge
      ln -s ${bash}/bin/bash $out/sublime_bash
      wrapProgram $out/sublime_bash \
        --set LD_PRELOAD "${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1"

      wrapProgram $out/sublime_merge \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects}
    '';
  };
in stdenv.mkDerivation (rec {
  name = "sublimemerge-${buildVersion}";

  phases = [ "installPhase" ];

  inherit sublimeMerge;

  installPhase = ''
    mkdir -p $out/bin

    cat > $out/bin/sublM <<-EOF
    #!/bin/sh
    exec $sublimeMerge/sublime_merge "\$@"
    EOF
    chmod +x $out/bin/sublM

    ln $out/bin/sublM $out/bin/sublime_merge
    ln $out/bin/sublM $out/bin/sublimeMerge
    mkdir -p $out/share/applications
    ln -s $sublimeMerge/sublime_merge.desktop $out/share/applications/sublime_merge.desktop
    ln -s $sublimeMerge/Icon/256x256/ $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "Meet a new Git client, from the makers of Sublime Text";
    homepage = https://www.sublimemerge.com/;
    maintainers = with maintainers; [ jonoabroad ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
})
