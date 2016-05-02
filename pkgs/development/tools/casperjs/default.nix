{ stdenv, fetchFromGitHub, fontsConf, phantomjs2, python, nodePackages }:

let version = "1.1.1";

in stdenv.mkDerivation rec {

  name = "casperjs-${version}";

  src = fetchFromGitHub {
    owner = "casperjs";
    repo = "casperjs";
    rev = version;
    sha256 = "187prrm728xpn0nx9kxfxa4fwd7w25z78nsxfk6a6kl7c5656jpz";
  };

  buildInputs = [ phantomjs2 python nodePackages.eslint ];

  patchPhase = ''
    substituteInPlace bin/casperjs --replace "/usr/bin/env python" "${python}/bin/python" \
                                   --replace "'phantomjs'" "'${phantomjs2}/bin/phantomjs'"
  '';

  dontBuild = true;

  doCheck = true;
  checkPhase = ''
    export FONTCONFIG_FILE=${fontsConf}
    make test
  '';


  installPhase = ''
    mv $PWD $out
  '';

  meta = {

    description = ''
      Navigation scripting & testing utility for PhantomJS and SlimerJS
    '';

    longDescription = ''
      CasperJS is a navigation scripting & testing utility for PhantomJS and
      SlimerJS (still experimental). It eases the process of defining a full
      navigation scenario and provides useful high-level functions, methods &
      syntactic sugar for doing common tasks.
    '';

    homepage = http://casperjs.org;
    license = stdenv.lib.licenses.mit;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
