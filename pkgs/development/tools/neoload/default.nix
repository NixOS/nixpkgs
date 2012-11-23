{ stdenv, fetchurl, writeTextFile, oraclejre, makeWrapper, licenseAccepted ? false }:

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

# the installer is very picky and demands 1.6.0.29
let dotInstall4j = writeTextFile { name = "dot-install4j"; text = ''
      JRE_VERSION	${oraclejre}	1	6	0	29
      JRE_INFO	${oraclejre}	0
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
  name = "neoload-4.0.4";

  src = fetchurl (
    if stdenv.system == "x86_64-linux" then
      { url = http://www.neotys.com/documents/download/neoload/v4.0/neoload_4_0_4_linux_x64.sh;
        sha256 = "1w5pqik1998irpamx6y4rf2v5v34nm8xm6cwa1a8j0agawv992w2"; }
    else
      { url = http://www.neotys.com/documents/download/neoload/v4.0/neoload_4_0_4_linux_x86.sh;
        sha256 = "0k49kcwnimax9q7d2kychcbhh4zlixlx4ak9jgrm901zpkhw2f3b"; } );

  buildInputs = [ makeWrapper ];
  phases = [ "installPhase" ];

  # TODO: load generator / monitoring agent only builds

  installPhase = ''
    # the installer wants to use its internal JRE
    # disable this. The extra spaces are needed because the installer carries
    # a binary payload, so should not change in size
    sed -e 's/^if \[ -f jre.tar.gz/if false          /' $src > installer
    chmod a+x installer

    cp ${dotInstall4j} .install4j
    chmod u+w .install4j

    sed -e "s|INSTALLDIR|$out|" ${responseVarfile} > response.varfile

    export HOME=`pwd`
    export INSTALL4J_JAVA_HOME=${oraclejre}
    ./installer -q -varfile response.varfile

    for i in $out/bin/*; do
      wrapProgram $i --run 'cp ${dotInstall4j} ~/.install4j' \
                     --run 'chmod u+w ~/.install4j'
    done

    mkdir -p $out/share/applications
    for i in $out/lib/neoload/*.desktop; do
      name=$(basename "$i")
      sed -e 's|/lib/neoload/bin|/bin|' "$i" > "$out/share/applications/$name"
    done
    rm $out/lib/neoload/*.desktop $out/lib/neoload/uninstall

    ln -s ${oraclejre}/bin $out/lib/neoload/jre
  '';

  meta = {
    description = "load testing software for Web applications to realistically simulate user activity and analyze server behavior.";

    homepage = https://www.neotys.com/product/overview-neoload.html;

    # https://www.neotys.com/documents/legal/eula/neoload/eula_en.html
    license = stdenv.lib.licenses.proprietary;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
