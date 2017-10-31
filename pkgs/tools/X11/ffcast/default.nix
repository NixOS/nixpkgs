{ stdenv, fetchFromGitHub, autoreconfHook, perl, libX11 }:

stdenv.mkDerivation rec {
  name = "ffcast-${version}";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "lolilolicon";
    repo = "FFcast";
    rev = "${version}";
    sha256 = "047y32bixhc8ksr98vwpgd0k1xxgsv2vs0n3kc2xdac4krc9454h";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perl libX11 ];

  configureFlags = [ "--disable-xrectsel" ];

  postBuild = ''
    make install
  '';

  meta = with stdenv.lib; {
    description = "Run commands on rectangular screen regions";
    homepage = https://github.com/lolilolicon/FFcast;
    license = licenses.gpl3;
    maintainers = [ maintainers.guyonvarch ];
    platforms = platforms.linux;
  };
}
