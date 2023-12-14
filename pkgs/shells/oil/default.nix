{ stdenv, lib, fetchurl, symlinkJoin, withReadline ? true, readline }:

let
  readline-all = symlinkJoin {
    name = "readline-all"; paths = [ readline readline.dev ];
  };
in
stdenv.mkDerivation rec {
  pname = "oil";
  version = "0.19.0";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    hash = "sha256-iCoEFudFqxjYZerhOe7u6bPzN5EUOpwSpWCbTzUmF8U=";
  };

  postPatch = ''
    patchShebangs build
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  strictDeps = true;
  buildInputs = lib.optional withReadline readline;
  configureFlags = [
    "--datarootdir=${placeholder "out"}"
  ] ++ lib.optionals withReadline [
    "--with-readline"
    "--readline=${readline-all}"
  ];

  # Stripping breaks the bundles by removing the zip file from the end.
  dontStrip = true;

  meta = {
    description = "A new unix shell";
    homepage = "https://www.oilshell.org/";

    license = with lib.licenses; [
      psfl # Includes a portion of the python interpreter and standard library
      asl20 # Licence for Oil itself
    ];

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lheckemann alva ];
    changelog = "https://www.oilshell.org/release/${version}/changelog.html";
  };

  passthru = {
    shellPath = "/bin/osh";
  };
}
