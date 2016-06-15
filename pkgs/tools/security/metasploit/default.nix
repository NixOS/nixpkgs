{ stdenv, lib, git, fetchgit
, bundlerEnv, bundler, makeWrapper, ruby
, postgresql, libpcap, sqlite, zlib
}:

stdenv.mkDerivation rec {
  name = "metasploit-framework-${version}";
  version = "4.12.5";

  buildInputs = [ makeWrapper git postgresql libpcap sqlite zlib ruby bundler ];
  dontBuild = true;

  src = fetchgit {
    rev = "refs/tags/${version}";
    url = "https://github.com/rapid7/metasploit-framework";
    sha256 = "1cxcy9gqnajrdb0idmyn2m5dj3fnm6z55axpd1j9ss2c4kwln08c";
  };

  configurePhase = ''

    mkdir -p $out/share/metasploit
    cp -R *  $out/share/metasploit
    rm -f    $out/share/metasploit/Gemfile.lock

    export sourceRoot=$out/share/metasploit
    export GEM_HOME=$GEM_HOME:${ruby}${ruby.gemPath}
    export GEM_PATH=$GEM_PATH:$GEM_HOME
  '';

  installPhase = ''
    bundler install --gemfile=$out/share/metasploit/Gemfile --path=$out

    for i in $out/share/metasploit/msf*; do
        makeWrapper $i $out/bin/$(basename $i) \
          --prefix "GEM_HOME" : "$GEM_HOME" \
          --prefix "GEM_PATH" : "$GEM_PATH:${bundler}/${ruby.gemPath}"
    done
  '';

  postInstall = ''
    patchShebangs $out/share/metasploit
  '';

  meta = {
    description = "Metasploit Framework - a collection of exploits";
    homepage = https://github.com/rapid7/metasploit-framework/wiki;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.endian0a ];
  };
}
