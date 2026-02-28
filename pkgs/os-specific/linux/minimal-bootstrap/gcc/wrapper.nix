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
  pname = "gcc-wrapper";
  extraFlags = (lib.optionalString (!libgcc.sharedAvailable) "-static-libgcc ");
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
    mkdir -p "$out/bin"
    for orig in ${gcc-unwrapped}/bin/*gcc ${gcc-unwrapped}/bin/*gcc-${gcc-unwrapped.version}; do
      sed \
        -e 's,@bash@,${lib.getExe bash},' \
        -e "s,@gcc@,$orig," \
        -e "s,@origname@,$(basename "$orig")," \
        -e "s,@origdir@,${gcc-unwrapped}/libexec/gcc," \
        -e 's,@dynlinker@,${libc}/${libc.dynamicLinkerFile},' \
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
        -e 's,@dynlinker@,${libc}/${libc.dynamicLinkerFile},' \
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
