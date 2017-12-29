{stdenv, darwin}:

/*
 * This is needed to build GCC on Darwin.
 *
 * These are the collection of headers that would normally be available under
 * /usr/include in macOS machines with command line tools installed. They need
 * to be in one folder for gcc to use them correctly.
 */

stdenv.mkDerivation {
  name = "darwin-usr-include";
  buildInputs = [ darwin.CF stdenv.libc ];
  buildCommand = ''
    mkdir -p $out
    cd $out
    ln -sf ${stdenv.libc}/include/* .
    mkdir CoreFoundation
    ln -sf ${darwin.CF}/Library/Frameworks/CoreFoundation.framework/Headers/* CoreFoundation
  '';
}
