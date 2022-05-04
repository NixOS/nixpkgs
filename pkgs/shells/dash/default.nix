{ lib
, stdenv
, buildPackages
, autoreconfHook
, fetchurl
, fetchpatch
, libedit
, runCommand
, dash
}:

stdenv.mkDerivation rec {
  pname = "dash";
  version = "0.5.11.4";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${pname}-${version}.tar.gz";
    sha256 = "13g06zqfy4n7jkrbb5l1vw0xcnjvq76i16al8fjc5g33afxbf5af";
  };

  hardeningDisable = [ "format" ];

  patches = [
    (fetchpatch {
      # Dash executes code when noexec ("-n") is specified
      # https://www.openwall.com/lists/oss-security/2020/11/11/3
      url = "https://git.kernel.org/pub/scm/utils/dash/dash.git/patch/?id=29d6f2148f10213de4e904d515e792d2cf8c968e";
      sha256 = "0aadb7aaaan6jxmi6icv4p5gqx7k510yszaqsa29b5giyxz5l9i1";
    })

    # aarch64-darwin fix from upstream; remove on next release
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/utils/dash/dash.git/patch/?id=6f6d1f2da03468c0e131fdcbdcfa9771ffca2614";
      sha256 = "16iz2ylkyhpxqq411ns8pjk8rizh6afhavvsf052wvzsnmmlvfbw";
    })
  ];

  # configure.ac patched; remove on next release
  nativeBuildInputs = [ autoreconfHook ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ libedit ];

  configureFlags = [ "--with-libedit" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 gpl2 ];
  };

  passthru = {
    shellPath = "/bin/dash";
    tests = {
      "execute-simple-command" = runCommand "${pname}-execute-simple-command" { } ''
        mkdir $out
        ${dash}/bin/dash -c 'echo "Hello World!" > $out/success'
        [ -s $out/success ]
        grep -q "Hello World" $out/success
      '';
    };
  };
}
