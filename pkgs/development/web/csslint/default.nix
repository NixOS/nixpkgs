{ stdenv, fetchurl, nodejs }:

stdenv.mkDerivation rec {
  version = "0.10.0";
  pname = "csslint";

  src = fetchurl {
    url = "https://registry.npmjs.org/csslint/-/${pname}-${version}.tgz";
    sha256 = "1gq2x0pf2p4jhccvn3y3kjhm1lmb4jsfdbzjdh924w8m3sr9jdid";
  };

  # node is the interpreter used to run this script
  buildInputs = [ nodejs ];

  installPhase = ''
    sed -i "s/path\.join/path\.resolve/g" cli.js # fixes csslint issue #167
    mkdir -p $out/bin;
    cp -r * $out/bin
    mv $out/bin/cli.js $out/bin/csslint
  '';

  meta = with stdenv.lib; {
    description = "Checks CSS for syntax errors and other problems";
    longDescription = ''
      CSSLint is a tool to help point out problems with your CSS
      code. It does basic syntax checking as well as applying a set of
      rules to the code that look for problematic patterns or signs of
      inefficiency. The rules are all pluggable, so you can easily
      write your own or omit ones you don't want. '';
    homepage = https://nodejs.org;
    license = licenses.bsd2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
