{ stdenv, fetchgit, makeWrapper, ruby, bundler, bundlerEnv, git, postgresql, libpcap, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "metasploit-framework-${version}";
  version = "4.12.5";


  src = fetchgit {
    url = "https://github.com/rapid7/metasploit-framework.git";
    sha256 = "0rzn2lax3nvhgmfivr7jdifir9j8f1f7mk2ypksr8lvqk4hr54kw";
  };


  buildInputs = [makeWrapper bundler git postgresql libpcap sqlite zlib ruby];

  installPhase = ''
    mkdir -p $out/share/msf
    mkdir -p $out/bin

    cp -r * $out/share/msf

    bundle install --path=$out/.gem


    # !!! Must manually set bundler gem path !!!! 
    export GEM_HOME=$out/.gem
    export HOME=$out/.gem/bin:$PATH

    for i in $out/share/msf/msf*; do
        makeWrapper $i $out/bin/$(basename $i) --prefix RUBYLIB : $out/share/msf/lib
    done
  '';

  postInstall = ''
    patchShebangs $out/share/msf
  '';

  meta = {
    description = "Metasploit Framework - a collection of exploits";
    homepage = https://github.com/rapid7/metasploit-framework/wiki;
  };
}
