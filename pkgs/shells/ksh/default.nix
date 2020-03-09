{ stdenv, meson, ninja, fetchFromGitHub, which, python, fetchpatch
, libiconv }:

stdenv.mkDerivation rec {
  pname = "ksh";
  version = "2020.0.0";

  src = fetchFromGitHub {
    owner  = "att";
    repo   = "ast";
    rev    = version;
    sha256 = "0cdxz0nhpq03gb9rd76fn0x1yzs2c8q289b7vcxnzlsrz1imz65j";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/att/ast/commit/11983a71f5e29df578b7e2184400728b4e3f451d.patch";
      sha256 = "1n9558c4v2qpgpjb1vafs29n3qn3z0770wr1ayc0xjf5z5j4g3kv";
    })
  ];

  nativeBuildInputs = [ meson ninja which python ];

  buildInputs = [ libiconv ];

  meta = with stdenv.lib; {
    description = "KornShell Command And Programming Language";
    longDescription = ''
      The KornShell language was designed and developed by David G. Korn at
      AT&T Bell Laboratories. It is an interactive command language that
      provides access to the UNIX system and to many other systems, on the
      many different computers and workstations on which it is implemented.
    '';
    homepage = https://github.com/att/ast;
    license = licenses.cpl10;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/ksh";
  };
}
