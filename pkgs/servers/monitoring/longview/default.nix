{stdenv, fetchFromGitHub, perl, perlPackages, makeWrapper, glibc }:

stdenv.mkDerivation rec {
  version = "1.1.5pre";
  name = "longview-${version}";

  src = fetchFromGitHub {
    owner = "linode";
    repo = "longview";
    rev = "5bcc9b60896b72de2d14f046f911477c26eb70ba";
    sha256 = "1i6va44bx2zfgbld7znf1slph0iqidlahq2xh3kd8q4lhvbrjn02";
  };

  patches = [
    # log to systemd journal
    ./log-stdout.patch
  ];

  postPatch = ''
    substituteInPlace Linode/Longview/Util.pm --replace /var/run/longview.pid /run/longview.pid
  '';

  buildInputs = [ perl makeWrapper glibc ]
    ++ (with perlPackages; [
      LWPUserAgent
      LWPProtocolHttps
      MozillaCA
      CryptSSLeay
      IOSocketInet6
      LinuxDistribution
      JSONPP
      JSON
      LogLogLite
      TryTiny
      DBI
      DBDmysql
    ]);

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/usr
    mv Linode $out
    ln -s ../Linode/Longview.pl $out/bin/longview
    for h in syscall.h sys/syscall.h asm/unistd.h asm/unistd_32.h asm/unistd_64.h bits/wordsize.h bits/syscall.h; do
        ${perl}/bin/h2ph -d $out ${glibc}/include/$h
        mkdir -p $out/usr/include/$(dirname $h)
        mv $out${glibc}/include/''${h%.h}.ph $out/usr/include/$(dirname $h)
    done
    wrapProgram $out/Linode/Longview.pl --prefix PATH : ${perl}/bin:$out/bin \
     --suffix PERL5LIB : $out/Linode --suffix PERL5LIB : $PERL5LIB \
     --suffix PERL5LIB : $out --suffix INC : $out
  '';

  meta = with stdenv.lib; {
    homepage = https://www.linode.com/longview;
    description = "Longview collects all of your system-level metrics and sends them to Linode";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rvl ];
    inherit version;
  };
}
