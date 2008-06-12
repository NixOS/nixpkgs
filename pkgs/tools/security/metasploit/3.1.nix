args : with args; 
rec {
  src = fetchurl {
    url = http://www.packetstormsecurity.nl/UNIX/utilities/framework-3.1.tar.gz;
    sha256 = "114znq9dfcyh9gcj57p3zsc0d0amlzhwidmg8qjcgxpjh28h1afx";
  };

  buildInputs = [makeWrapper];
  configureFlags = [];

  doInstall = FullDepEntry(''
    ensureDir $out/share/msf
    ensureDir $out/bin

    cp -r * $out/share/msf

    for i in $out/share/msf/msf*; do
        makeWrapper $i $out/bin/$(basename $i) --prefix RUBYLIB : $out/share/msf/lib
    done
  '') ["minInit" "defEnsureDir" "doUnpack" "addInputs"];

  /* doConfigure should be specified separately */
  phaseNames = ["doInstall" (doPatchShebangs "$out/share/msf")];
      
  name = "metasploit-framework" + version;
  meta = {
    description = "Metasploit Framework - a collection of exploits";
    homepage = "http://framework.metasploit.org/";
  };
}

