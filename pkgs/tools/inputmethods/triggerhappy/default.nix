{ stdenv, fetchFromGitHub, pkgconfig, perl, systemd }:

stdenv.mkDerivation rec {
  pname = "triggerhappy";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "wertarbyte";
    repo = "triggerhappy";
    rev = "release/${version}";
    sha256 = "0gb1qhrxwq7i5abd408d01a2dpf28nr1fph1fg7w7n0i5i1nnk90";
  };

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ systemd ];

  makeFlags = [ "PREFIX=$(out)" "BINDIR=$(out)/bin" ];

  postInstall = ''
    install -D -m 644 -t "$out/etc/triggerhappy/triggers.d" "triggerhappy.conf.examples"
  '';

  meta = with stdenv.lib; {
    description = "A lightweight hotkey daemon";
    longDescription = ''
      Triggerhappy is a hotkey daemon developed with small and embedded systems in
      mind, e.g. linux based routers. It attaches to the input device files and
      interprets the event data received and executes scripts configured in its
      configuration.
    '';
    homepage = "https://github.com/wertarbyte/triggerhappy/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau taha ];
  };
}
