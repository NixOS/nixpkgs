{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name    = "infer-${version}";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/facebook/infer/releases/download/v${version}/infer-linux64-v${version}.tar.xz";
    sha256 = "1kppiayzqwmm13aq8x1jxd3j4jywh3h37jxrgyipz8li1ddpdq3m";
  };

  buildInputs = [ python ];
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/libexec $out/bin;
    cp -R facebook-clang-plugin $out/libexec
    cp -R infer $out/libexec
    for x in `ls $out/libexec/infer/infer/bin`; do
      ln -s $out/libexec/infer/infer/bin/$x $out/bin/$x;
    done
  '';
  fixupPhase = ''
    patchShebangs $out
  '';

  meta = {
    description = "Scalable static analyzer for Java, C and Objective-C";
    homepage    = http://fbinfer.com;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = [ "x86_64-linux" ];
  };
}
