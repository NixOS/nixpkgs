{ lib, stdenv, fetchFromGitHub, libedit, autoreconfHook, zlib, unzip, libtommath, libtomcrypt, icu, superServer ? false }:

let base = {
  pname = "firebird";

  meta = with lib; {
    description = "SQL relational database management system";
    downloadPage = "https://github.com/FirebirdSQL/firebird/";
    homepage = "https://firebirdsql.org/";
    changelog = "https://github.com/FirebirdSQL/firebird/blob/master/CHANGELOG.md";
    license = [ "IDPL" "Interbase-1.0" ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ marcweber ];
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libedit icu ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [ icu ];

  configureFlags = [
    "--with-system-editline"
  ] ++ (lib.optional superServer "--enable-superserver");

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r gen/Release/firebird/* $out
    runHook postInstall
  '';

}; in rec {

  firebird_2_5 = stdenv.mkDerivation (base // rec {
    version = "2.5.9";

    src = fetchFromGitHub {
      owner = "FirebirdSQL";
      repo = "firebird";
      rev = "R${builtins.replaceStrings [ "." ] [ "_" ] version}";
      sha256 = "sha256-YyvlMeBux80OpVhsCv+6IVxKXFRsgdr+1siupMR13JM=";
    };

    configureFlags = base.configureFlags ++ [ "--with-system-icu" ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r gen/firebird/* $out
      runHook postInstall
    '';

    meta = base.meta // { platforms = [ "x86_64-linux" ]; };
  });

  firebird_3 = stdenv.mkDerivation (base // rec {
    version = "3.0.9";

    src = fetchFromGitHub {
      owner = "FirebirdSQL";
      repo = "firebird";
      rev = "v${version}";
      sha256 = "0axgw4zzb7f7yszr8s7svnspv3mgyvpbkb0b3w6c70fnj10hw21c";
    };

    buildInputs = base.buildInputs ++ [ zlib libtommath ];

    meta = base.meta // { platforms = [ "x86_64-linux" ]; };
  });

  firebird_4 = stdenv.mkDerivation (base // rec {
    version = "4.0.1";

    src = fetchFromGitHub {
      owner = "FirebirdSQL";
      repo = "firebird";
      rev = "v${version}";
      sha256 = "sha256-0XUu1g/VTrklA3vCpX6HWr7sdW2eQupnelpFNSGcouM=";
    };

    buildInputs = base.buildInputs ++ [ zlib unzip libtommath libtomcrypt ];
  });

  firebird = firebird_4;
}
