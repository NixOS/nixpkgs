{
  fetchurl,
  lib,
  gnutar,
  xz,
  bash-build,
  gnused,
  targetPlatform,
  libc,
  libgcc,
  libstdcxx,
  gcc-unwrapped,
  binutils,
  bash,
}:
let
  common = import ./common.nix {
    inherit
      lib
      bash
      fetchurl
      gnutar
      xz
      ;
  };
  pname = "gcc-wrapper";
  extraFlags = (lib.optionalString (!libgcc.sharedAvailable) "-static-libgcc ");
  # adapted from bintools-wrapper
  dynamicLinkerGlob = common.dynamicLinkerGlob targetPlatform libc;
in
bash-build.runCommand "${pname}-${gcc-unwrapped.version}"
  {
    inherit pname;
    version = gcc-unwrapped.version;
    meta = gcc-unwrapped.meta;
    nativeBuildInputs = [ gnused ];
    passthru.unwrapped = gcc-unwrapped;
  }
  ''
    if [[ -z '${dynamicLinkerGlob}' ]]; then
      echo "Don't know the name of the dynamic linker for platform '${targetPlatform.config}', so guessing instead."
      dynamicLinker="${libc}/lib/ld*.so.?"
    else
      dynamicLinker='${dynamicLinkerGlob}'
    fi
    dynamicLinker=($dynamicLinker)
    case ''${#dynamicLinker[@]} in
      0) echo "No dynamic linker found for platform '${targetPlatform.config}'.";;
      1) echo "Using dynamic linker: '$dynamicLinker'";;
      *) echo "Multiple dynamic linkers found for platform '${targetPlatform.config}'.";;
    esac

    mkdir -p "$out/bin"
    for orig in ${gcc-unwrapped}/bin/*gcc ${gcc-unwrapped}/bin/*gcc-${gcc-unwrapped.version}; do
      sed \
        -e 's,@bash@,${lib.getExe bash},' \
        -e "s,@gcc@,$orig," \
        -e "s,@origname@,$(basename "$orig")," \
        -e "s,@origdir@,${gcc-unwrapped}/libexec/gcc," \
        -e "s,@dynlinker@,$dynamicLinker," \
        -e 's,@libgcc@,${libgcc}/lib/gcc/${targetPlatform.config}/${libgcc.version},' \
        -e 's,@libc@,${libc}/lib,' \
        -e 's,@gccinc@,${gcc-unwrapped}/lib/gcc/${targetPlatform.config}/${libgcc.version}/include,' \
        -e 's,@binutils@,${binutils}/bin,' \
        -e 's,@extraflags@,${extraFlags},' \
        '${./wrapper.sh}' > "$out/bin/$(basename "$orig")"
        chmod +x "$out/bin/$(basename "$orig")"
    done
    for orig in ${gcc-unwrapped}/bin/*++; do
      sed \
        -e 's,@bash@,${lib.getExe bash},' \
        -e "s,@gcc@,$orig," \
        -e "s,@origname@,$(basename "$orig")," \
        -e "s,@origdir@,${gcc-unwrapped}/libexec/gcc," \
        -e "s,@dynlinker@,$dynamicLinker," \
        -e 's,@libgcc@,${libgcc}/lib/gcc/${targetPlatform.config}/${libgcc.version},' \
        -e 's,@libc@,${libc}/lib,' \
        -e 's,@libstdcxx@,${libstdcxx}/lib,' \
        -e 's,@libstdcxxinc@,${libstdcxx}/include/c++/${libstdcxx.version},' \
        -e 's,@libstdcxxarchinc@,${libstdcxx}/include/c++/${libstdcxx.version}/${targetPlatform.config},' \
        -e 's,@gccinc@,${gcc-unwrapped}/lib/gcc/${targetPlatform.config}/${libgcc.version}/include,' \
        -e 's,@binutils@,${binutils}/bin,' \
        -e 's,@extraflags@,${extraFlags},' \
        '${./wrappercxx.sh}' > "$out/bin/$(basename "$orig")"
        chmod +x "$out/bin/$(basename "$orig")"
    done
    for orig in ${gcc-unwrapped}/bin/*cpp ${gcc-unwrapped}/bin/*-ar ${gcc-unwrapped}/bin/*-nm ${gcc-unwrapped}/bin/*-ranlib; do
      ln -s "$orig" "$out/bin/$(basename "$orig")"
    done
  ''
