{stdenv}:

rec {

  inherit stdenv;

   curl = (import ./curl-static) {
     inherit stdenv;
   };

   ### TOOLS
   coreutils = (import ./coreutils-static) {
     inherit stdenv gnutar gzip curl;
   };

   findutils = (import ./findutils-static) {
     inherit stdenv gnutar gzip curl;
   };

   diffutils = (import ./diffutils-static) {
     inherit stdenv gnutar gzip curl;
   };

   gnused = (import ./gnused-static) {
     inherit stdenv gnutar gzip curl;
   };

   gnugrep = (import ./gnugrep-static) {
     inherit stdenv gnutar gzip curl;
   };

   gawk = (import ./gawk-static) {
     inherit stdenv gnutar gzip curl;
   };

   gnutar = (import ./gnutar-static) {
     inherit stdenv;
   };

   gzip = (import ./gzip-static) {
     inherit stdenv;
   };

   bzip2 = (import ./bzip2-static) {
     inherit stdenv gnutar gzip curl;
   };

   binutils = (import ./binutils-static) {
     inherit stdenv gnutar gzip curl;
   };

   gnumake = (import ./gnumake-static) {
     inherit stdenv gnutar gzip curl;
   };

   gcc = (import ./gcc-static) {
     inherit stdenv;
   };

   bash = (import ./bash-static) {
     inherit stdenv;
   };

}
