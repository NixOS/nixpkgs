{lib, stdenv, fetchFromGitHub, erlang, pam, perl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "yaws";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "erlyaws";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-F1qhq0SEChWw/EBodXKWTqMNmGoTwP2JgkmfANUFD9I=";
  };

  configureFlags = [ "--with-extrainclude=${pam}/include/security" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ erlang pam perl ];

  postInstall = ''
    sed -i "s#which #type -P #" $out/bin/yaws
  '';

  meta = with lib; {
    description = "A webserver for dynamic content written in Erlang.";
    homepage = "https://github.com/erlyaws/yaws";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu ];
  };

}
