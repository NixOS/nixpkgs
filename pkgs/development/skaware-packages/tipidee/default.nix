{
  skawarePackages,
  stdenv,
  skalibs,
}:

skawarePackages.buildPackage {
  pname = "tipidee";
  version = "0.0.8.0";
  sha256 = "sha256-GjllM2YqxwvCsKC4xlYW/6f6IBUIhZMA67mtM82mEC0=";

  meta.description = "HTTP 1.1 webserver, serving static files and CGI/NPH";

  outputs = [
    "bin"
    "lib"
    "dev"
    "doc"
    "out"
  ];

  buildInputs = [ skalibs ];

  configureFlags = [
    "--libdir=${placeholder "lib"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "lib"}/libexec"
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"

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

  meta.broken = stdenv.hostPlatform.isDarwin;
}
