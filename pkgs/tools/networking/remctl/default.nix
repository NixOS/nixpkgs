{ stdenv, lib, autoreconfHook, fetchgit, libkrb5, libevent, openssl, perl
, pkg-config }:

stdenv.mkDerivation rec {
  pname = "remctl";
  version = "3.17";

  src = fetchgit {
    url = "git://git.eyrie.org/kerberos/remctl.git";
    rev = "release/${version}";
    sha256 = "1n7nwp2zqq806wbcnnamrsjfx250m4hfqqq94gz3fiqbgdrqs9pw";
  };

  outputs = [ "out" "perlsrc" "pythonsrc" ];

  postPatch = ''
    # Fix references to /usr/bin/perl in tests.
    patchShebangs tests
    # Disable acl/localgroup test that does not work in sandbox.
    sed -i '/server\/acl\/localgroup/d' tests/TESTS
  '';

  nativeBuildInputs = [ autoreconfHook perl pkg-config ];
  buildInputs = [ libkrb5 libevent openssl ];

  # Invokes pod2man to create man pages required by Makefile.
  preConfigure = ''
    ./bootstrap
  '';

  makeFlags = [
    "LD=$(CC)"
    "REMCTL_PERL_FLAGS='--prefix=$(out)'"
    "REMCTL_PYTHON_INSTALL='--prefix=$(out)'"
  ];

  checkTarget = "check-local";

  # Copy automake-customized perl & python source to their own outputs
  # for later consumption by the perl & python packages.
  postInstall = ''
    cp -R perl $perlsrc
    cp -R tests/tap/perl/Test $perlsrc/t/lib
    cp -R python $pythonsrc
  '';

  meta = with lib; {
    description = "GSSAPI-authenticated remote commands";
    homepage = "https://git.eyrie.org/git/kerberos/remctl.git";
    # https://www.eyrie.org/~eagle/software/remctl/license.html
    license = licenses.free;
    maintainers = [ teams.deshaw.members ];
  };
}
