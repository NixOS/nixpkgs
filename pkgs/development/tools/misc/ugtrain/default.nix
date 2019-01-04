{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, glib, enableGlib ? true
, stdenv_32bit, enableMultiLib ? false # probably you should install pkgsi686Linux.ugtrain instead of setting this true
}@args:

let
  inherit (stdenv.lib) optional;
  stdenv = if enableMultiLib then stdenv_32bit else args.stdenv;
  version = "0.4.1";
in

stdenv.mkDerivation {

  name = "ugtrain-${version}";

  src = fetchFromGitHub {
    owner = "ugtrain";
    repo = "ugtrain";
    rev = "v${version}";
    sha256 = "0pw9lm8y83mda7x39874ax2147818h1wcibi83pd2x4rp1hjbkkn";
  };

  buildInputs = [
    autoreconfHook
    pkgconfig
  ] ++ optional enableGlib glib;

  configureFlags = optional enableGlib     "--enable-glib"
                ++ optional enableMultiLib "--enable-multilib";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The ugtrain (say You-Gee-train) is an advanced free and universal game trainer for the command line";
    longDescription = ''
      It is a research project and a tool for advanced users who want latest
      and really working Linux game cheating methods at the cost of no GUI and
      limited usability.

      The **dynamic memory support** sets ugtrain apart. An integrated
      preloader, a memory discovery, and a memory hacking library are included
      for this.  It uses one simple **config file per game** which can be
      exchanged with others. **Example configs** for games which allow cheating
      are included.  These also come with **automatic adaptation** for dynamic
      memory so that you can use them right away on your system after executing
      it.

      Furthermore, security measures like **ASLR/PIC/PIE are bypassed**.
      Together with **universal checks**, reliable and stable static memory
      cheating is provided.  Ugtrain works with most C/C++ games on Linux this
      way. With **scanmem** it integrates the best memory search on Linux and
      there is even **no need for root privileges**.
    '';
    homepage = https://github.com/ugtrain/ugtrain;
    license = licenses.gpl3;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ elitak ];
  };

}
