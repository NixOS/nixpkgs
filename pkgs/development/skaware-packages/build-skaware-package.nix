{
  lib,
  stdenv,
  cleanPackaging,
  fetchurl,
  nix-update-script,
  pkg-config,
}:
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "sha256"
    "manpages"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      sha256 ? lib.fakeSha256,
      manpages ? null,
      meta ? { },
      outputs ? [
        "bin"
        "lib"
        "dev"
        "doc"
        "out"
      ],
      nativeBuildInputs ? [ ],
      configureFlags,
      passthru ? { },
      ...
    }@args:
    let
      # File globs that can always be deleted
      commonNoiseFiles = [
        ".gitignore"
        "Makefile"
        "INSTALL"
        "configure"
        "patch-for-solaris"
        "src/**/*"
        "tools/**/*"
        "package/**/*"
        "config.mak"
        "*.pc"
      ];
      # File globs that should be moved to $doc
      commonMetaFiles = [
        "COPYING"
        "AUTHORS"
        "NEWS"
        "CHANGELOG"
        "README"
        "README.*"
        "DCO"
        "CONTRIBUTING"
      ];
      libraryOutput = if lib.elem "lib" outputs then "lib" else "out";
    in
    {
      src = fetchurl {
        url = "https://skarnet.org/software/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
        inherit sha256;
      };
      outputs =
        if manpages == null then
          outputs
        else
          assert (
            lib.assertMsg (!lib.elem "man" outputs)
              "If you pass `manpages` to `skawarePackages.buildPackage`, you cannot have a `man` output already!"
          );
          if lib.length outputs > 0 then
            [
              (lib.head outputs)
              "man"
            ]
            ++ lib.tail outputs
          else
            [ "man" ];
      dontDisableStatic = true;
      enableParallelBuilding = true;
      nativeBuildInputs = [ pkg-config ] ++ nativeBuildInputs;
      configureFlags =
        configureFlags
        ++ [
          "--enable-absolute-paths"
          # We assume every Nix-based cross target has urandom.
          # This might not hold for e.g. BSD.
          "--with-sysdep-devurandom=yes"
          (if stdenv.hostPlatform.isDarwin then "--disable-shared" else "--enable-shared")
          # Use pkg-config
          "--with-pkgconfig=pkg-config"
          "--enable-pkgconfig"
        ]
        # On Darwin, the target triplet from -dumpmachine includes version number,
        # but skarnet.org software uses the triplet to test binary compatibility.
        # Explicitly setting target ensures code can be compiled against a skalibs
        # binary built on a different version of Darwin.
        # http://www.skarnet.org/cgi-bin/archive.cgi?1:mss:623:heiodchokfjdkonfhdph
        ++ (lib.optional stdenv.hostPlatform.isDarwin "--build=${stdenv.hostPlatform.system}");
      makeFlags = lib.optionals stdenv.cc.isClang [
        "AR=${stdenv.cc.targetPrefix}ar"
        "RANLIB=${stdenv.cc.targetPrefix}ranlib"
      ];
      postInstall = ''
        echo "Cleaning & moving common files"
        ${
          cleanPackaging.commonFileActions {
            noiseFiles = commonNoiseFiles;
            docFiles = commonMetaFiles;
          }
        } $doc/share/doc/${finalAttrs.pname}

        ${
          if manpages == null then
            ''echo "no manpages for this package"''
          else
            ''
              echo "copying manpages"
              cp -vr ${manpages} $man
            ''
        }

        ${args.postInstall or ""}
      '';
      postFixup = ''
        if [ -d "$dev/lib/pkgconfig" ]; then
          for pc in "$dev"/lib/pkgconfig/*.pc; do
            sed -i "s|^libdir=.*|libdir=${placeholder libraryOutput}/lib|" "$pc"
            if ! grep -q '^Libs.private:' "$pc"; then
              sed -i "/^Libs:/a Libs.private: -L${placeholder libraryOutput}/lib" "$pc"
            fi
          done
        fi
        ${cleanPackaging.checkForRemainingFiles}
      '';
      passthru = {
        updateScript = nix-update-script {
          extraArgs = [
            "--url"
            "https://github.com/skarnet/${finalAttrs.pname}"
            "--override-filename"
            "pkgs/development/skaware-packages/${finalAttrs.pname}/default.nix"
          ];
        };
      }
      // passthru
      // (if manpages == null then { } else { inherit manpages; });
      meta = {
        homepage = "https://skarnet.org/software/${finalAttrs.pname}/";
        platforms = lib.platforms.all;
        license = lib.licenses.isc;
        maintainers =
          with lib.maintainers;
          [
            pmahoney
            Profpatsch
            qyliss
          ]
          ++ (meta.maintainers or [ ]);
      }
      // meta;
    };
}
