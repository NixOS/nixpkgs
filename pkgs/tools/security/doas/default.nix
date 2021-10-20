{ lib
, stdenv
, fetchFromGitHub
, bison
, pam

, withPAM ? true
, withTimestamp ? true
}:

stdenv.mkDerivation rec {
  pname = "doas";
  version = "6.8.1";

  src = fetchFromGitHub {
    owner = "Duncaen";
    repo = "OpenDoas";
    rev = "v${version}";
    sha256 = "sha256-F0FVVspGDZmzxy4nsb/wsEoCw4eHscymea7tIKrWzD0=";
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
  ];

  postPatch = ''
    sed -i '/\(chown\|chmod\)/d' GNUmakefile
  '';

  buildInputs = [ bison pam ];

  meta = with lib; {
    description = "Executes the given command as another user";
    homepage = "https://github.com/Duncaen/OpenDoas";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cole-h cstrahan ];
  };
}
