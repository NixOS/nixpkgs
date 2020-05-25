{ stdenv
, lib
, fetchFromGitHub
, bison
, pam

, withTimestamp ? true
}:

stdenv.mkDerivation rec {
  pname = "doas";
  version = "6.6.1";

  src = fetchFromGitHub {
    owner = "Duncaen";
    repo = "OpenDoas";
    rev = "v${version}";
    sha256 = "07kkc5729p654jrgfsc8zyhiwicgmq38yacmwfvay2b3gmy728zn";
  };

  # otherwise confuses ./configure
  dontDisableStatic = true;

  configureFlags = [
    (lib.optionalString withTimestamp "--with-timestamp") # to allow the "persist" setting
    "--pamdir=${placeholder "out"}/etc/pam.d"
  ];

  postPatch = ''
    sed -i '/\(chown\|chmod\)/d' bsd.prog.mk
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
