{ skawarePackages, stdenv, skalibs }:

skawarePackages.buildPackage {
  pname = "tipidee";
  version = "0.0.5.0";
  sha256 = "2ekfxxmHmkPVQym5mwLGZJxU5Cjne8lqBXNQa1K/FCI=";

  description = "HTTP 1.1 webserver, serving static files and CGI/NPH";

  outputs = [ "bin" "lib" "out" "dev" "doc" ];

  configureFlags = [
    "--libdir=\${lib}/lib"
    "--libexecdir=\${lib}/libexec"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"

    # we set sysconfdir to /etc here to allow tipidee-config
    # to look in the global paths for its configs.
    # This is not encouraged, but a valid use-case.
    "--sysconfdir=/etc"
  ];

  postInstall = ''
    # remove all tipidee executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libtipidee.*

    mv doc $doc/share/doc/tipidee/html
    mv examples $doc/share/doc/tipidee/examples
  '';

  broken = stdenv.hostPlatform.isDarwin;
}
