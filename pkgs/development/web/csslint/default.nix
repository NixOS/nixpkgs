{ stdenv, fetchurl, nodejs }:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "csslint-${version}";

  src = fetchurl {
    url = "http://registry.npmjs.org/csslint/-/${name}.tgz";
    sha256 = "ee7a79c8f2af1c228d4b7869b6681d0d02a93568774dbf51c7a45aa1ffa1da14";
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
    description = "checks CSS for syntax errors and other problems";
    longDescription = ''
      CSSLint is a tool to help point out problems with your CSS
      code. It does basic syntax checking as well as applying a set of
      rules to the code that look for problematic patterns or signs of
      inefficiency. The rules are all pluggable, so you can easily
      write your own or omit ones you don't want. '';
    homepage = http://nodejs.org;
    license = licenses.bsd2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
