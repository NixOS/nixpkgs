{ stdenv, fetchurl, writeTextFile, jre, makeWrapper, fontsConf, licenseAccepted ? false }:

# If you happen to use this software on the XMonad window manager, you will have issues with
# grey windows, no resizing, menus not showing and other glitches.
# This can be fixed by setting a different WM name:
# http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#Using_SetWMName

if !licenseAccepted then throw ''
    You have to accept the neoload EULA at
    https://www.neotys.com/documents/legal/eula/neoload/eula_en.html
    by setting nixpkgs config option 'neoload.accept_license = true';
  ''
else assert licenseAccepted;

# the installer is very picky and demands 1.7.0.07
let dotInstall4j = path: writeTextFile { name = "dot-install4j"; text = ''
      JRE_VERSION	${path}	1	7	0	7
      JRE_INFO	${path}	94
    ''; };

    responseVarfile = writeTextFile { name = "response.varfile"; text = ''
      sys.programGroupDisabled$Boolean=false
      sys.component.Monitor\ Agent$Boolean=true
      sys.component.Common$Boolean=true
      sys.component.Controller$Boolean=true
      sys.languageId=en
      sys.component.Load\ Generator$Boolean=true
      sys.installationTypeId=Controller
      sys.installationDir=INSTALLDIR/lib/neoload
      sys.symlinkDir=INSTALLDIR/bin
    ''; };

in stdenv.mkDerivation rec {
  name = "neoload-4.1.4";

  src = fetchurl (
    if stdenv.hostPlatform.system == "x86_64-linux" then
      { url = http://neoload.installers.neotys.com/documents/download/neoload/v4.1/neoload_4_1_4_linux_x64.sh;
        sha256 = "199jcf5a0nwfm8wfld2rcjgq64g91vvz2bkmki8dxfzf1yasifcd"; }
    else
      { url = http://neoload.installers.neotys.com/documents/download/neoload/v4.1/neoload_4_1_4_linux_x86.sh;
        sha256 = "1z66jiwcxixsqqwa0f4q8m2p5kna4knq6lic8y8l74dgv25mw912"; } );

  buildInputs = [ makeWrapper ];
  phases = [ "installPhase" ];

  # TODO: load generator / monitoring agent only builds

  installPhase = ''
    mkdir -p $out/lib/neoload

    # the installer wants to use its internal JRE
    # disable this. The extra spaces are needed because the installer carries
    # a binary payload, so should not change in size
    sed -e 's/^if \[ -f jre.tar.gz/if false          /' $src > installer
    chmod a+x installer

    cp ${dotInstall4j jre} .install4j
    chmod u+w .install4j

    sed -e "s|INSTALLDIR|$out|" ${responseVarfile} > response.varfile

    export HOME=`pwd`
    export INSTALL4J_JAVA_HOME=${jre.home}
    export FONTCONFIG_FILE=${fontsConf}
    bash -ic './installer -q -varfile response.varfile'

    sed -i 's/Xmx450m/Xmx900m/;s/Xss192k/Xss384k/' $out/lib/neoload/conf/agent.properties

    for i in $out/bin/*; do
      wrapProgram $i --run 'cp ${dotInstall4j "${jre.home}/jre"} ~/.install4j' \
                     --run 'chmod u+w ~/.install4j'
    done

    mkdir -p $out/share/applications
    for i in $out/lib/neoload/*.desktop; do
      name=$(basename "$i")
      sed -e 's|/lib/neoload/bin|/bin|' "$i" > "$out/share/applications/$name"
    done
    rm -r $out/lib/neoload/*.desktop $out/lib/neoload/uninstall

  '';

  meta = {
    description = "Load testing software for Web applications to realistically simulate user activity and analyze server behavior";

    homepage = https://www.neotys.com/product/overview-neoload.html;

    # https://www.neotys.com/documents/legal/eula/neoload/eula_en.html
    license = stdenv.lib.licenses.unfree;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
