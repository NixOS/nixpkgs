{ lib
, stdenv
, fetchFromGitHub
, bison
, pam
, libxcrypt

, withPAM ? true
, withTimestamp ? true
}:

stdenv.mkDerivation rec {
  pname = "doas";
  version = "6.8.2";

  src = fetchFromGitHub {
    owner = "Duncaen";
    repo = "OpenDoas";
    rev = "v${version}";
    sha256 = "9uOQ2Ta5HzEpbCz2vbqZEEksPuIjL8lvmfmynfqxMeM=";
  };

  # otherwise confuses ./configure
  dontDisableStatic = true;

  configureFlags = [
    (lib.optionalString withTimestamp "--with-timestamp") # to allow the "persist" setting
    (lib.optionalString (!withPAM) "--without-pam")
  ];

  patches = [
    # Allow doas to discover binaries in /run/current-system/sw/{s,}bin and
    # /run/wrappers/bin
    ./0001-add-NixOS-specific-dirs-to-safe-PATH.patch

    # Standard environment supports "dontDisableStatic" knob, but has no
    # equivalent for "--disable-shared", so I have to patch "configure"
    # script instead.
    ./disable-shared.patch
  ];

  postPatch = ''
    sed -i '/\(chown\|chmod\)/d' GNUmakefile
  '' + lib.optionalString (withPAM && stdenv.hostPlatform.isStatic) ''
    sed -i 's/-lpam/-lpam -laudit/' configure
  '';

  nativeBuildInputs = [ bison ];
  buildInputs = [ ]
    ++ lib.optional withPAM pam
    ++ lib.optional (!withPAM) libxcrypt;

  meta = with lib; {
    description = "Executes the given command as another user";
    homepage = "https://github.com/Duncaen/OpenDoas";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cole-h cstrahan ];
  };
}
