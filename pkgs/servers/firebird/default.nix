{
  lib,
  stdenv,
  fetchFromGitHub,
  libedit,
  autoreconfHook271,
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
      license = [
        "IDPL"
        "Interbase-1.0"
      ];
      platforms = platforms.linux;
      maintainers = with maintainers; [
        bbenno
        marcweber
      ];
    };

    nativeBuildInputs = [ autoreconfHook271 ];

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
      rm $out/lib/*.a  # they were just symlinks to /build/source/...
      runHook postInstall
    '';

  };
in
rec {
  firebird_3 = stdenv.mkDerivation (
    base
    // rec {
      version = "3.0.12";

      src = fetchFromGitHub {
        owner = "FirebirdSQL";
        repo = "firebird";
        rev = "v${version}";
        hash = "sha256-po8tMrOahfwayVXa7Eadr9+ZEmZizHlCmxi094cOJSY=";
      };

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
      version = "4.0.5";

      src = fetchFromGitHub {
        owner = "FirebirdSQL";
        repo = "firebird";
        rev = "v${version}";
        hash = "sha256-OxkPpmnYTl65ns+hKHJd5IAPUiMj0g3HUpyRpwDNut8=";
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
