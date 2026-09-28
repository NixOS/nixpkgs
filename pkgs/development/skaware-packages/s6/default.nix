{
  lib,
  skawarePackages,
  skalibs,
  execline,
  execlineSupport ? true,
  components ? null,
}:

skawarePackages.buildPackage {
  pname = "s6";
  version = "2.15.1.0";
  sha256 = "sha256-6rnEbiK2axYTX5oF7Gig6ih9kGC4TRDe+qosqtFYq1I=";

  manpages = skawarePackages.buildManPages {
    pname = "s6-man-pages";
    version = "2.14.0.1.4";
    sha256 = "sha256-c77NwS4x5L1nLmtWVz64izzanTfc0hohvFMOi77uMh4=";
    description = "Port of the documentation for the s6 supervision suite to mdoc";
    maintainers = [ lib.maintainers.sternenseemann ];
  };

  meta.description = "skarnet.org's small & secure supervision software suite";

  # NOTE lib: cannot split lib from bin at the moment,
  # since some parts of lib depend on executables in bin.
  # (the `*_startf` functions in `libs6`)
  outputs = [
    # "bin" "lib"
    "out"
    "dev"
    "doc"
  ];

  buildInputs = [
    skalibs
  ]
  ++ lib.optionals execlineSupport [
    execline
  ];

  postPatch = lib.optionalString (components != null) ''
    for d in ${lib.escapeShellArgs components}; do
      if [ ! -d "src/$d" ]; then
        echo "s6: components: no such program group: src/$d" >&2
        exit 1
      fi
    done

    keep=$(awk -v groups=${lib.escapeShellArg (toString components)} '
      BEGIN { n = split(groups, g, " "); for (i = 1; i <= n; i++) want[g[i]] = 1 }
      /^[a-zA-Z0-9_.-]+: src\// {
        prog = $1; sub(/:$/, "", prog)
        dir = $2; sub(/^src\//, "", dir); sub(/\/.*$/, "", dir)
        if (dir in want) print prog
      }
    ' package/deps.mak | sort -u | tr '\n' ' ')

    if [ -z "$keep" ]; then
      echo "s6: components: matched no programs" >&2
      exit 1
    fi

    echo "BIN_TARGETS := \$(filter $keep,\$(BIN_TARGETS))" >> package/targets.mak
  '';

  # TODO: nsss support
  configureFlags = [
    "--libdir=${placeholder "out"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "out"}/libexec"
    "--bindir=${placeholder "out"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
  ]
  ++ lib.optionals (!execlineSupport) [
    "--disable-execline"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libs6.*
  ''
  # libs6auto is only built when execline is available.
  + lib.optionalString execlineSupport ''
    rm ./libs6auto.a.xyzzy
  ''
  + ''
    mv doc $doc/share/doc/s6/html
    mv examples $doc/share/doc/s6/examples
  '';

}
