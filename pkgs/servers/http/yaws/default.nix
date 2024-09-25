{lib, stdenv, fetchFromGitHub, erlang, pam, perl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "yaws";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "erlyaws";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-acO8Vc8sZJl22HUml2kTxVswLEirqMbqHQdRIbkkcvs=";
  };

  configureFlags = [ "--with-extrainclude=${pam}/include/security" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ erlang pam perl ];

  postInstall = ''
    sed -i "s#which #type -P #" $out/bin/yaws
  '';

  meta = with lib; {
    description = "Webserver for dynamic content written in Erlang";
    mainProgram = "yaws";
    homepage = "https://github.com/erlyaws/yaws";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ ];
  };

}
