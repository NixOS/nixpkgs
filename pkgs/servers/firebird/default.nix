{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchDebianPatch,
  libedit,
  autoreconfHook,
  zlib,
  unzip,
  libtommath,
  libtomcrypt,
  icu73,
  superServer ? false,
}:

let
  base = {
    pname = "firebird";

    meta = with lib; {
      description = "SQL relational database management system";
      downloadPage = "https://github.com/FirebirdSQL/firebird/";
      homepage = "https://firebirdsql.org/";
      changelog = "https://github.com/FirebirdSQL/firebird/blob/master/CHANGELOG.md";
      license = with lib.licenses; [
        mpl11
        interbase
      ];
      platforms = platforms.linux;
      maintainers = with maintainers; [
        bbenno
        marcweber
      ];
    };

    nativeBuildInputs = [ autoreconfHook ];

    buildInputs = [
      libedit
      icu73
    ];

    LD_LIBRARY_PATH = lib.makeLibraryPath [ icu73 ];

    configureFlags = [
      "--with-system-editline"
    ]
    ++ (lib.optional superServer "--enable-superserver");

    enableParallelBuilding = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r gen/Release/firebird/* $out
      rm -f $out/lib/*.a  # they were just symlinks to /build/source/...
      runHook postInstall
    '';

  };
in
rec {
  firebird_3 = stdenv.mkDerivation (
    base
    // rec {
      version = "3.0.13";

      src = fetchFromGitHub {
        owner = "FirebirdSQL";
        repo = "firebird";
        rev = "v${version}";
        hash = "sha256-ti3cFfByM2wxOLkAebwtFe25B5W7jOwi3f7MPYo/yUA=";
      };

      patches = [
        (fetchDebianPatch {
          pname = "firebird3.0";
          version = "3.0.13.ds7";
          debianRevision = "2";
          patch = "no-binary-gbaks.patch";
          hash = "sha256-LXUMM38PBYeLPdgaxLPau4HWB4ItJBBnx7oGwalL6Pg=";
        })
      ];

      buildInputs = base.buildInputs ++ [
        zlib
        libtommath
      ];

      meta = base.meta // {
        platforms = [ "x86_64-linux" ];
      };
    }
  );

  firebird_4 = stdenv.mkDerivation (
    base
    // rec {
      version = "4.0.6";

      src = fetchFromGitHub {
        owner = "FirebirdSQL";
        repo = "firebird";
        rev = "v${version}";
        hash = "sha256-65wfG6huDzvG/tEVllA58OfZqoL4U/ilw5YIDqQywTs=";
      };

      nativeBuildInputs = base.nativeBuildInputs ++ [ unzip ];
      buildInputs = base.buildInputs ++ [
        zlib
        libtommath
        libtomcrypt
      ];
    }
  );

  firebird = firebird_4;
}
